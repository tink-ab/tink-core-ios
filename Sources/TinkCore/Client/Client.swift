protocol Client {
    func performRequest(_ request: RESTRequest) -> Cancellable?
}
