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

public extension Period.Resolution {
    var statisticResolution: Statistic.Resolution {
        switch self {
        case .monthly:
            return .monthly
        case .monthlyAdjusted:
            return .monthlyAdjusted
        }
    }
}
