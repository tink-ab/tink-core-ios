import Foundation

extension Period {
    init?(restPeriod: RESTPeriod) {
        guard let start = restPeriod.startDate, let end = restPeriod.endDate, let resolution = restPeriod.resolution, let name = restPeriod.name else { return nil }
        self.init(dateInterval: DateInterval(start: start, end: end), name: name, resolution: Resolution(restResolution: resolution))
    }
}

extension Period.Resolution {
    init(restResolution: RESTPeriod.Resolution)  {
        switch restResolution {
        case .monthly: self = .monthly
        case .monthlyAdjusted: self = .monthlyAdjusted
        }
    }
}
