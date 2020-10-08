import Foundation

public protocol CredentialsService {
    func credentialsList(completion: @escaping (Result<[Credentials], Error>) -> Void) -> RetryCancellable?
    func credentials(id: Credentials.ID, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func create(providerName: Provider.Name, refreshableItems: RefreshableItems, fields: [String: String], appURI: URL?, callbackURI: URL?, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func delete(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func update(id: Credentials.ID, providerName: Provider.Name, appURI: URL?, callbackURI: URL?, fields: [String: String], completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func refresh(id: Credentials.ID, authenticate: Bool, refreshableItems: RefreshableItems, optIn: Bool, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func addSupplementalInformation(id: Credentials.ID, fields: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func cancelSupplementalInformation(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func enable(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func disable(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func thirdPartyCallback(state: String, parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func authenticate(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func qrCode(id: Credentials.ID, completion: @escaping (Result<Data, Error>) -> Void) -> RetryCancellable?
}
