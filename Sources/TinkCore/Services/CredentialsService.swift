import Foundation

public protocol CredentialsService {
    func credentialsList(completion: @escaping (Result<[Credentials], Error>) -> Void) -> RetryCancellable?
    func credentials(id: Credentials.ID, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func createCredentials(providerID: Provider.ID, refreshableItems: RefreshableItems, fields: [String: String], appURI: URL?, callbackURI: URL?, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func deleteCredentials(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func updateCredentials(id: Credentials.ID, providerID: Provider.ID, appURI: URL?, callbackURI: URL?, fields: [String: String], completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable?
    func refreshCredentials(id: Credentials.ID, refreshableItems: RefreshableItems, optIn: Bool, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func supplementInformation(id: Credentials.ID, fields: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func cancelSupplementInformation(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func enableCredentials(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func disableCredentials(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func thirdPartyCallback(state: String, parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func authenticateCredentials(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    func qr(id: Credentials.ID, completion: @escaping (Result<Data, Error>) -> Void) -> RetryCancellable?
}
