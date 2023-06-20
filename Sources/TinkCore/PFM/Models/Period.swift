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

extension Period.Resolution {
    public var statisticResolution: Statistic.Resolution {
        switch self {
        case .monthly:
            return .monthly
        case .monthlyAdjusted:
            return .monthlyAdjusted
        }
    }
}
