import Foundation

struct RESTPeriod: Decodable {
    enum Resolution: String, DefaultableDecodable, Encodable {
        case monthly = "MONTHLY"
        case monthlyAdjusted = "MONTHLY_ADJUSTED"
        case unknown

        static var decodeFallbackValue: Resolution = .unknown
    }

    let endDate: Date?
    let name: String?
    let resolution: Resolution?
    let startDate: Date?
}
