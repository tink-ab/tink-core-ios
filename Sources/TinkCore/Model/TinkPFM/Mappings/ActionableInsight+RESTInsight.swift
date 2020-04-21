import Foundation

extension ActionableInsight {
    init(from actionableInsight: RESTActionableInsight) {
        self.id = actionableInsight.id.flatMap(ID.init(_:))
        self.insight = Insight(
            title: actionableInsight.title ?? "",
            detail: actionableInsight.description ?? "",
            illustration: actionableInsight.data.flatMap({ Insight.Illustration(data: $0) }) ?? .icon(.uncategorized),
            color: Color.makeInsightColor(restInsightData: actionableInsight.data),
            dataType: .init(restInsightDataType: actionableInsight.data?.type)
        )
        self.actions = (actionableInsight.insightActions ?? []).enumerated().map { (offset, action) in
            let target = ActionableInsight.Action.Target(restInsightActionData: action.data ?? .unknown)
            return Action(title: action.label ?? "", isPrimary: offset == 0, target: target)
        }
        self.performedAction = nil
    }

    init(from archivedInsight: RESTArchivedInsight) {
        self.id = archivedInsight.id.flatMap(ID.init(_:))
        self.insight = Insight(
            title: archivedInsight.title ?? "",
            detail: archivedInsight.description ?? "",
            illustration: archivedInsight.data.flatMap({ Insight.Illustration(data: $0) }) ?? .icon(.uncategorized),
            color: Color.makeInsightColor(restInsightData: archivedInsight.data),
            dataType: .init(restInsightDataType: archivedInsight.data?.type)
        )
        self.actions = []
        self.performedAction = archivedInsight.dateArchived
    }
}

extension ActionableInsight.Action.Target {
    init(restInsightActionData: RESTInsightActionData) {
        switch restInsightActionData {
        case .unknown:
            self = .dismiss
        case .acknowledge:
            self = .acknowledge
        case .dismiss:
            self = .dismiss
        case .viewBudget(let data):
            self = .viewBudget(.init(budgetId: .init(data.budgetId), budgetPeriodStartTime: data.budgetPeriodStartTime))
        case .createTransfer(let data):
            let currencyDenominatedAmount = data.amount.map {
                CurrencyDenominatedAmount($0.amount, currencyCode: .init($0.currencyCode))
            }
            self = .createTransfer(.init(sourceAccount: data.sourceAccount, destinationAccount: data.destinationAccount, amount: currencyDenominatedAmount))
        case .viewTransaction(let data):
            self = .viewTransaction(.init(data.transactionId))
        case .categorizeExpense(let data):
            self = .categorizeExpense(.init(data.transactionId))
        case .viewTransactions(let data):
            let ids = data.transactionIds.map(Transaction.ID.init(_:))
            self = .viewTransactions(ids)
        case .categorizeTransactions(let data):
            let ids = data.transactionIds.map(Transaction.ID.init(_:))
            self = .categorizeTransactions(ids)
        case .viewTransactionsByCategory(let data):
            var dictionary = [Category.Code: [Transaction.ID]]()
            for (categoryCode, transactions) in data.transactionIdsByCategory {
                dictionary[.init(categoryCode)] = transactions.transactionIds.map(Transaction.ID.init(_:))
            }
            self = .viewTransactionsByCategory(dictionary)
        }
    }
}

extension ActionableInsight.Insight.DataType {
    init(restInsightDataType: RESTInsightDataType?) {
        switch restInsightDataType {
        case .none:
            self = .unknown
        case .accountBalanceLow:
            self = .accountBalanceLow
        case .budgetOverspent:
            self = .budgetOverspent
        case .budgetCloseNegative:
            self = .budgetCloseNegative
        case .budgetClosePositive:
            self = .budgetClosePositive
        case .budgetSuccess:
            self = .budgetSuccess
        case .budgetSummaryAchieved:
            self = .budgetSummaryAchieved
        case .budgetSummaryOverspent:
            self = .budgetSummaryOverspent
        case .largeExpense:
            self = .largeExpense
        case .singleUncategorizedTransaction:
            self = .singleUncategorizedTransaction
        case .doubleCharge:
            self = .doubleCharge
        case .weeklyUncategorizedTransactions:
            self = .weeklyUncategorizedTransactions
        case .weeklySummaryExpensesByCategory:
            self = .weeklySummaryExpensesByCategory
        case .weeklySummaryExpensesByDay:
            self = .weeklySummaryExpensesByDay
        case .monthlySummaryExpensesByCategory:
            self = .monthlySummaryExpensesByCategory
        }
    }
}
