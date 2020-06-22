import Foundation

struct RESTPeriod: Decodable {
    enum Resolution: String, Codable {
        case monthly = "MONTHLY"
        case monthlyAdjusted = "MONTHLY_ADJUSTED"
    }

    let endDate: Date?
    let name: String?
    let resolution: Resolution?
    let startDate: Date?
}
