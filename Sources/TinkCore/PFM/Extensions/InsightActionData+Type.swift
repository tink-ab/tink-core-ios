extension InsightActionData {
    var type: String? {
        switch self {
        case .unknown:
            return nil
        case .acknowledge:
            return "ACKNOWLEDGE"
        case .dismiss:
            return "DISMISS"
        case .viewBudget:
            return "VIEW_BUDGET"
        case .createTransfer:
            return "CREATE_TRANSFER"
        case .viewTransaction:
            return "VIEW_TRANSACTION"
        case .categorizeExpense:
            return "CATEGORIZE_EXPENSE"
        case .viewTransactions:
            return "VIEW_TRANSACTIONS"
        case .categorizeTransactions:
            return "CATEGORIZE_TRANSACTIONS"
        case .viewTransactionsByCategory:
            return "VIEW_TRANSACTIONS_BY_CATEGORY"
        case .viewAccount:
            return "VIEW_ACCOUNT"
        case .viewLeftToSpend:
            return "VIEW_LEFT_TO_SPEND"
        case .createBudget:
            return "CREATE_BUDGET"
        case .refreshCredentials:
            return "REFRESH_CREDENTIAL"
        }
    }
}
