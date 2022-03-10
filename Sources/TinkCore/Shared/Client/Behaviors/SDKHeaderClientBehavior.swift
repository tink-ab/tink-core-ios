import Foundation

final class SDKHeaderClientBehavior: ClientBehavior {
    var version: String
    var sdkName: String
    private let clientID: String

    init(sdkName: String, clientID: String) {
        self.sdkName = sdkName
        self.clientID = clientID
        self.version = TinkCore.version
    }

    var headers: [String: String] {
        var headers = ["X-Tink-SDK-Name": sdkName]
        headers["X-Tink-SDK-Version"] = version
        headers["X-Tink-OAuth-Client-ID"] = clientID
        return headers
    }
}
