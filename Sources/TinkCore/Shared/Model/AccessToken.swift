/// An OAuth access token to access the Tink service.
public struct AccessToken: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init(_ value: String) {
        self.rawValue = value
    }
}
