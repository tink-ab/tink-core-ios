extension PeriodMode {
    init(restPeriodMode: RESTPeriodMode) {
        switch restPeriodMode {
        case .monthly:
            self = .monthly
        case .monthlyAdjusted:
            self = .monthlyAdjusted
        }
    }

    var restPeriodMode: RESTPeriodMode {
        switch self {
        case .monthly:
            return .monthly
        case .monthlyAdjusted:
            return .monthlyAdjusted
        }
    }
}
