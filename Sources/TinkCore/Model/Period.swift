import Foundation

public struct Period {
    public enum Resolution {
        case monthly
        case monthlyAdjusted
    }

    public let dateInterval: DateInterval
    public let name: String
    public let resolution: Resolution
}
