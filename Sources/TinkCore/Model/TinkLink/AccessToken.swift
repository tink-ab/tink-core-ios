/// An oauth access token to access the Tink service
public struct AccessToken: Hashable, RawRepresentable, Decodable {
    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ value: String) {
        self.rawValue = value
    }
}
