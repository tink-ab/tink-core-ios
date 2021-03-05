import Dispatch

public protocol ProviderService {
    func providers(name: Provider.Name?, capabilities: Provider.Capabilities?, includeTestProviders: Bool, excludeNonTestProviders: Bool, completion: @escaping (Result<[Provider], Error>) -> Void) -> RetryCancellable?
}
