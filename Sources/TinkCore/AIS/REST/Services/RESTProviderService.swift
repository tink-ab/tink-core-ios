import Foundation

final class RESTProviderService: ProviderService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func providers(name: Provider.Name?, capabilities: Provider.Capabilities?, includeTestProviders: Bool, excludeNonTestProviders: Bool, completion: @escaping (Result<[Provider], Error>) -> Void) -> RetryCancellable? {
        var parameters = [
            URLQueryItem(name: "includeTestProviders", value: includeTestProviders ? "true" : "false"),
            URLQueryItem(name: "excludeNonTestProviders", value: excludeNonTestProviders ? "true" : "false")
        ]

        if let name = name {
            parameters.append(.init(name: "name", value: name.value))
        }

        if let restCapabilities = capabilities?.restCapabilities, restCapabilities.count == 1 {
            parameters.append(.init(name: "capability", value: restCapabilities[0].rawValue))
        }

        let request = RESTResourceRequest<RESTProviders>(path: "/api/v1/providers", method: .get, contentType: .json, parameters: parameters) { result in

            do {
                var providers = try result.get().providers.map(Provider.init)

                if let capabilities = capabilities {
                    providers = providers.filter {
                        !$0.capabilities.isDisjoint(with: capabilities)
                    }
                }
                completion(.success(providers))
            } catch {
                completion(.failure(error))
            }
        }

        return client.performRequest(request)
    }

    func providers(market: Market, capabilities: Provider.Capabilities?, includeTestProviders: Bool, excludeNonTestProviders: Bool, completion: @escaping (Result<[Provider], Error>) -> Void) -> RetryCancellable? {
        var parameters = [
            URLQueryItem(name: "includeTestProviders", value: includeTestProviders ? "true" : "false"),
            URLQueryItem(name: "excludeNonTestProviders", value: excludeNonTestProviders ? "true" : "false")
        ]

        if let restCapabilities = capabilities?.restCapabilities, restCapabilities.count == 1 {
            parameters.append(.init(name: "capability", value: restCapabilities[0].rawValue))
        }

        let request = RESTResourceRequest<RESTProviders>(path: "/api/v1/providers/\(market.rawValue)", method: .get, contentType: .json) { result in

            do {
                let providers = try result.get().providers.map(Provider.init)
                completion(.success(providers))
            } catch {
                completion(.failure(error))
            }
        }

        return client.performRequest(request)
    }
}
