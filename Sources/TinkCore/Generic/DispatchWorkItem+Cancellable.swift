import Dispatch

extension DispatchWorkItem: RetryCancellable {
    public func retry() {}
}
