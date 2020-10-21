import Foundation

extension Credentials {

    enum Error: Swift.Error {
        case supplementalInformationMissing
    }

    init(restCredentials: RESTCredentials, appUri: URL) {
        guard let id = restCredentials.id, let type = restCredentials.type, let status = restCredentials.status else { fatalError() }
        self.id = .init(id)
        self.providerName = .init(restCredentials.providerName)
        self.kind = .init(restCredentialType: type)
        self.status = .init(restCredentialsStatus: status, id: id, supplementalInformation: restCredentials.supplementalInformation, appUri: appUri)
        self.statusPayload = restCredentials.statusPayload
        self.statusUpdated = restCredentials.statusUpdated
        self.updated = restCredentials.updated
        self.fields = restCredentials.fields
        self.sessionExpiryDate = restCredentials.sessionExpiryDate
    }

    static func makeFieldSpecifications(from string: String?) throws -> [Provider.FieldSpecification] {
        guard let string = string else {
            throw Error.supplementalInformationMissing
        }

        if let stringData = string.data(using: .utf8) {
            let fields = try JSONDecoder().decode([RESTField].self, from: stringData)
            if fields.isEmpty {
                throw Error.supplementalInformationMissing
            }
            return fields.map(Provider.FieldSpecification.init)
        } else {
            throw Error.supplementalInformationMissing
        }
    }

    static func makeThirdPartyAppAuthentication(from string: String?, id: String, status: RESTCredentials.Status?, appUri: URL) -> Credentials.ThirdPartyAppAuthentication? {
        guard let status = status else {
            return nil
        }

        switch status {
        case .awaitingMobileBankidAuthentication:

            guard let url = URL(string: "bankid:///"), var bankIDComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return nil
            }

            let redirectQueryItem = URLQueryItem(name: "redirect", value: appUri.appendingPathComponent("bankid/credentials/\(id)").absoluteString)

            if let autostartToken = string {
                let autostartTokenQueryItem = URLQueryItem(name: "autostartToken", value: autostartToken)
                bankIDComponents.queryItems = [autostartTokenQueryItem, redirectQueryItem]
            } else {
                bankIDComponents.queryItems = [redirectQueryItem]
            }
            let deepLinkURL = bankIDComponents.url

            return ThirdPartyAppAuthentication(
                downloadTitle: "Download Mobile BankID",
                downloadMessage: "You need to install the Mobile BankID app to authenticate",
                upgradeTitle: "",
                upgradeMessage: "",
                appStoreURL: URL(string: "itms://itunes.apple.com/se/app/bankid-sakerhetsapp/id433151512"),
                scheme: "bankid://",
                deepLinkURL: deepLinkURL
            )

        case .awaitingThirdPartyAppAuthentication:
            guard let payloadData = string?.data(using: .utf8),
                let payload = try? JSONDecoder().decode(RESTThirdPartyAppAuthenticationPayload.self, from: payloadData)
            else { return nil }

            return ThirdPartyAppAuthentication(
                downloadTitle: payload.downloadTitle,
                downloadMessage: payload.downloadMessage,
                upgradeTitle: payload.upgradeTitle,
                upgradeMessage: payload.upgradeMessage,
                appStoreURL: payload.ios.appStoreUrl,
                scheme: payload.ios.scheme,
                deepLinkURL: payload.ios.deepLinkUrl
            )
        default:
            return nil
        }
    }
}

extension Credentials.Kind {
    init(restCredentialType: RESTCredentials.ModelType) {
        switch restCredentialType {
        case .thirdPartyApp:
            self = .thirdPartyAuthentication
        case .password:
            self = .password
        case .mobileBankid:
            self = .mobileBankID
        case .keyfob:
            self = .keyfob
        case .unknown:
            self = .unknown
        }
    }

    init(restCredentialType: RESTProvider.CredentialsType) {
        switch restCredentialType {
        case .thirdPartyApp:
            self = .thirdPartyAuthentication
        case .password:
            self = .password
        case .mobileBankid:
            self = .mobileBankID
        case .keyfob:
            self = .keyfob
        case .unknown:
            self = .unknown
        }
    }

    var restCredentialsType: RESTCredentials.ModelType? {
        switch self {
        case .unknown:
            return nil
        case .password:
            return .password
        case .mobileBankID:
            return .mobileBankid
        case .keyfob:
            return .keyfob
        case .thirdPartyAuthentication:
            return .thirdPartyApp
        }
    }
}

extension Credentials.Status {
    init(restCredentialsStatus: RESTCredentials.Status, id: String, supplementalInformation: String?, appUri: URL) {
        switch restCredentialsStatus {
        case .created:
            self = .created
        case .authenticating:
            self = .authenticating
        case .updating:
            self = .updating
        case .updated:
            self = .updated
        case .temporaryError:
            self = .temporaryError
        case .authenticationError:
            self = .authenticationError
        case .permanentError:
            self = .permanentError
        case .awaitingMobileBankidAuthentication:
            if let thirdPartyAppAuthentication = Credentials.makeThirdPartyAppAuthentication(from: supplementalInformation, id: id, status: restCredentialsStatus, appUri: appUri) {
                self = .awaitingMobileBankIDAuthentication(thirdPartyAppAuthentication)
            } else {
                assertionFailure("Failed to parse third party app authentication. You may need to update your version of TinkCore.")
                self = .authenticationError
            }
        case .awaitingThirdPartyAppAuthentication:
            if let thirdPartyAppAuthentication = Credentials.makeThirdPartyAppAuthentication(from: supplementalInformation, id: id, status: restCredentialsStatus, appUri: appUri) {
                self = .awaitingThirdPartyAppAuthentication(thirdPartyAppAuthentication)
            } else {
                assertionFailure("Failed to parse third party app authentication. You may need to update your version of TinkCore.")
                self = .authenticationError
            }
        case .awaitingSupplementalInformation:
            do {
                let fields = try Credentials.makeFieldSpecifications(from: supplementalInformation)
                self = .awaitingSupplementalInformation(fields)
            } catch {
                assertionFailure("Failed to parse supplemental information. You may need to update your version of TinkCore. Underlying error: \(error)")
                self = .authenticationError
            }
        case .sessionExpired:
            self = .sessionExpired
        case .deleted:
            self = .disabled
        case .unknown:
            self = .unknown
        }
    }
}
