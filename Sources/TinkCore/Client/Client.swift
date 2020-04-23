protocol Client {
    func performRequest(_ request: RESTRequest) -> RetryCancellable?
}
