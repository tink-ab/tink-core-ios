enum RESTPeriodMode: String, DefaultableDecodable {
    case monthly = "MONTHLY"
    case monthlyAdjusted = "MONTHLY_ADJUSTED"
    case unknown

    static var decodeFallbackValue: RESTPeriodMode = .unknown
}
