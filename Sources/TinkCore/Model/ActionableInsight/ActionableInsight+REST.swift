import Foundation

extension ActionableInsight {
    init?(restInsight: RESTActionableInsight) {
        guard let id = restInsight.id,
            let data = restInsight.data,
            let type = restInsight.type,
            let kind = Kind(restType: type, restInsightData: data),
            let actions = restInsight.insightActions,
            let title = restInsight.title,
            let description = restInsight.description,
            let created = restInsight.createdTime else {
                return nil
        }

        let state = State.active(actions.map { InsightAction(label: $0.label, data: $0.data.flatMap(InsightActionData.init)) })
        self = .init(id: ID(id), kind: kind, state: state, title: title, description: description, created: created)
    }

    init?(restArchivedInsight: RESTArchivedInsight) {
        guard let id = restArchivedInsight.id,
            let data = restArchivedInsight.data,
            let type = restArchivedInsight.type,
            let kind = Kind(restType: type, restInsightData: data),
            let title = restArchivedInsight.title,
            let description = restArchivedInsight.description,
            let archivedDate = restArchivedInsight.dateArchived,
            let created = restArchivedInsight.dateInsightCreated else {
                return nil
        }

       let state = State.archived(archivedDate)
       self = .init(id: ID(id), kind: kind, state: state, title: title, description: description, created: created)
    }
}

extension ActionableInsight.Kind {
    init?(restType: RESTActionableInsightType, restInsightData: RESTInsightData) {

        switch (restType, restInsightData) {
        case (.unknown, _): return nil // TODO: Do we want to expose an "unknown" type?

        case (.accountBalanceLow, .accountBalanceLow(let accountBalanceData)):
            let id = Account.ID(accountBalanceData.accountId)
            let balance = CurrencyDenominatedAmount(restAIAmount: accountBalanceData.balance)
            let data = ActionableInsight.AccountBalanceLowData(accountID: id, balance: balance)
            self = .accountBalanceLow(data)

        case (.budgetOverspent, .budgetOverspent(let summary)):
            let id = Budget.ID(summary.budgetId)
            let period = ActionableInsight.BudgetPeriod(restBudgetPeriod: summary.budgetPeriod)
            self = .budgetOverspent(.init(budgetId: id, budgetPeriod: period))

        case (.budgetCloseNegative, .budgetCloseNegative(let summary)):
            let id = Budget.ID(summary.budgetId)
            let period = ActionableInsight.BudgetPeriod(restBudgetPeriod: summary.budgetPeriod)
            self = .budgetCloseNegative(.init(budgetId: id, budgetPeriod: period))

        case (.budgetClosePositive, .budgetClosePositive(let summary)):
            let id = Budget.ID(summary.budgetId)
            let period = ActionableInsight.BudgetPeriod(restBudgetPeriod: summary.budgetPeriod)
            self = .budgetClosePositive(.init(budgetId: id, budgetPeriod: period))

        case (.budgetSuccess, .budgetSuccess(let summary)):
            let id = Budget.ID(summary.budgetId)
            let period = ActionableInsight.BudgetPeriod(restBudgetPeriod: summary.budgetPeriod)
            self = .budgetSuccess(.init(budgetId: id, budgetPeriod: period))

        case (.budgetSummaryAchieved, .budgetSummaryAchieved(let summary)):
            let summary = ActionableInsight.BudgetPeriodSummary(achievedBudgets: summary.achievedBudgets.map(ActionableInsight.BudgetSummary.init), overspentBudgets: summary.overspentBudgets.map(ActionableInsight.BudgetSummary.init), period: summary.periodUnit)
            self = .budgetSummaryAchieved(summary)

        case (.budgetSummaryOverspent, .budgetSummaryOverspent(let summary)):
            let summary = ActionableInsight.BudgetPeriodSummary(
                achievedBudgets: summary.achievedBudgets.map(ActionableInsight.BudgetSummary.init),
                overspentBudgets: summary.overspentBudgets.map(ActionableInsight.BudgetSummary.init),
                period: summary.periodUnit)
            self = .budgetSummaryOverspent(summary)

        case (.largeExpense, .largeExpense(let largeExpense)):
            self = .largeExpense(.init(transactionID: Transaction.ID(largeExpense.transactionId), amount: .init(restAIAmount: largeExpense.amount)))

        case (.singleUncategorizedTransaction, .singleUncategorizedTransaction(let transaction)):
            self = .singleUncategorizedTransaction(Transaction.ID(transaction.transactionId))

        case (.doubleCharge, .doubleCharge(let doubleCharge)):
            self = .doubleCharge(doubleCharge.transactionIds.map(Transaction.ID.init(_:)))

        case (.weeklyUncategorizedTransactions, .weeklyUncategorizedTransactions(let weeklyUncategorizedTransactions)):
            self = .weeklyUncategorizedTransactions(.init(transactionIDs: weeklyUncategorizedTransactions.transactionIds.map(Transaction.ID.init(_:)), week: .init(year: weeklyUncategorizedTransactions.week.year, week: weeklyUncategorizedTransactions.week.week)))

        case (.weeklySummaryExpensesByCategory, .weeklySummaryExpensesByCategory(let weeklyExpenses)):
            let expensesByCategory = ActionableInsight.WeeklyExpensesByCategory(
                week: .init(year: weeklyExpenses.week.year, week: weeklyExpenses.week.week),
                expensesByCategory: weeklyExpenses.expensesByCategory.map {
                    ActionableInsight.CategorySpending(categoryCode: Category.Code($0.categoryCode), spentAmount: .init(restAIAmount: $0.spentAmount))
            })
            self = .weeklySummaryExpensesByCategory(expensesByCategory)

        case (.weeklyExpensesByDay, .weeklySummaryExpensesByDay(let weeklyExpenses)):

            let expensesByDay = ActionableInsight.WeeklyExpensesByDay(
                week: .init(year: weeklyExpenses.week.year, week: weeklyExpenses.week.week),
                expenseStatisticsByDay: weeklyExpenses.expenseStatisticsByDay.map { ActionableInsight.WeeklyExpensesByDay.ExpenseStatisticsByDay(date: $0.date, expenseStatistics: .init(totalAmount: .init(restAIAmount: $0.expenseStatistics.totalAmount), averageAmount: .init(restAIAmount: $0.expenseStatistics.averageAmount))) })
            self = .weeklySummaryExpensesByDay(expensesByDay)

        case (.leftToSpendNegative, _):
            self = .leftToSpendNegative

        case (.weeklySummaryExpenseTransactions, _):
            self = .weeklySummaryExpenseTransactions

        case (.monthlySummaryExpenseTransactions, _):
            self = .monthlySummaryExpenseTransactions

        case (.newIncomeTransaction, _):
            self = .newIncomeTransaction

        default: return nil
        }
    }
}

extension ActionableInsight.BudgetPeriod {
    init(restBudgetPeriod: RESTInsightData.BudgetPeriod) {
        self = .init(dateInterval: .init(start: restBudgetPeriod.start, end: restBudgetPeriod.end), spentAmount: .init(restAIAmount: restBudgetPeriod.spentAmount), budgetAmount: .init(restAIAmount: restBudgetPeriod.budgetAmount))
    }
}

extension ActionableInsight.BudgetSummary {
    init(restSummary: RESTInsightData.BudgetSummary) {
        self = .init(budgetId: Budget.ID(restSummary.budgetId), budgetPeriod: .init(restBudgetPeriod: restSummary.budgetPeriod))
    }
}

extension InsightActionData {
    init(restAction: RESTInsightActionData) {
        switch restAction {
        case .acknowledge:
            self = .acknowledge
        case .unknown:
            self = .unknown
        case .dismiss:
            self = .dismiss
        case .viewBudget(let viewBudget):
            self = .viewBudget(.init(budgetID: Budget.ID(viewBudget.budgetId), budgetPeriodStartTime: viewBudget.budgetPeriodStartTime))
        case .createTransfer(let createTransfer):
            self = .createTransfer(.init(sourceAccount: createTransfer.sourceAccount, destinationAccount: createTransfer.destinationAccount, amount: createTransfer.amount.flatMap(CurrencyDenominatedAmount.init)))
        case .viewTransaction(let viewTransaction):
            self = .viewTransaction(Transaction.ID(viewTransaction.transactionId))
        case .categorizeExpense(let categorizeExpense):
            self = .categorizeExpense(Transaction.ID(categorizeExpense.transactionId))
        case .viewTransactions(let viewTransactions):
            self = .viewTransactions(viewTransactions.transactionIds.map(Transaction.ID.init(_:)))
        case .categorizeTransactions(let categorizeTransactions):
            self = .categorizeTransactions(categorizeTransactions.transactionIds.map(Transaction.ID.init(_:)))
        case .viewTransactionsByCategory(let transactionsByCategory):
            var categoryDict: [Category.Code: [Transaction.ID]] = [:]
            transactionsByCategory.transactionIdsByCategory.forEach({ categoryDict[Category.Code($0.key)] = $0.value.transactionIds.map(Transaction.ID.init(_:)) })
            self = .viewTransactionsByCategory(categoryDict)
        }
    }
}
