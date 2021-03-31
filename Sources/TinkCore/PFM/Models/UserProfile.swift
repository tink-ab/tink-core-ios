import Foundation

public struct UserProfile {
    public let currency: CurrencyCode
    public let locale: Locale
    public let market: Market
    public let periodAdjustedDay: Int
    public let periodMode: Period.Resolution?
    public let timeZone: TimeZone?

    @available(*, deprecated)
    public init(currency: CurrencyCode, locale: Locale, market: Market, periodAdjustedDay: Int, periodMode: Period.Resolution, timeZone: TimeZone?) {
        self.currency = currency
        self.locale = locale
        self.market = market
        self.periodAdjustedDay = periodAdjustedDay
        self.periodMode = periodMode
        self.timeZone = timeZone
    }
}
