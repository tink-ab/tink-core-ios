import Foundation

/// Description of a client using TinkLink.
public struct ClientDescription {
    public let iconURL: URL?
    /// The name of the client.
    public let name: String
    public let url: URL?
    public let isEmbeddedAllowed: Bool
    public let scopes: [ScopeDescription]
    /// Whether the client is verified.
    public let isVerified: Bool
    /// Whether the client is the aggregator.
    public let isAggregator: Bool
}
