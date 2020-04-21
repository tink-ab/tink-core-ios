extension Account {
    init(from account: RESTAccount) {
        let amount: CurrencyDenominatedAmount?
        if let restDenominatedAmount = account.currencyDenominatedBalance {
            amount = .init(unscaledValue: Int64(restDenominatedAmount.unscaledValue), scale: Int64(restDenominatedAmount.scale), currencyCode: restDenominatedAmount.currencyCode)
        } else {
            amount = nil
        }
        self = .init(id: .init(account.id), balance: amount, name: account.name, type: Kind(from: account.type), number: account.accountNumber)
    }
}

extension Account.Kind {
    init(from type: RESTAccountType) {
        switch type {
        case .checking:
            self = .checking
        case .savings:
            self = .savings
        case .investment:
            self = .investment
        case .mortgage:
            self = .mortgage
        case .creditCard:
            self = .creditCard
        case .loan:
            self = .loan
        case .pension:
            self = .pension
        case .other:
            self = .other
        case .external:
            self = .external
        }
    }
}
