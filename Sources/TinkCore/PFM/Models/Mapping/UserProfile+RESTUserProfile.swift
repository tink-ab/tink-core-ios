import Foundation

extension UserProfile {
    init(restUserProfile: RESTUserProfile) {
        self.currency = .init(restUserProfile.currency)
        self.locale = .init(identifier: restUserProfile.locale)
        self.market = .init(code: restUserProfile.market)
        self.periodAdjustedDay = restUserProfile.periodAdjustedDay
        self.periodMode = .init(restPeriodMode: restUserProfile.periodMode)
        self.timeZone = TimeZone(identifier: restUserProfile.timeZone)
    }
}

extension Period.Resolution {
    init(restPeriodMode: RESTPeriodMode) {
        switch restPeriodMode {
        case .monthly: self = .monthly
        case .monthlyAdjusted: self = .monthlyAdjusted
        }
    }
}
