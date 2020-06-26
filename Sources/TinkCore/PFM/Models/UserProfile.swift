import Foundation

public struct UserProfile {
    public let currency: CurrencyCode
    public let locale: Locale
    public let market: Market
    public let periodAdjustedDay: Int
    public let periodMode: Period.Resolution
    public let timeZone: TimeZone?
}
