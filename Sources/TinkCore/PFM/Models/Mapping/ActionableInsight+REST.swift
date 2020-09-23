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
            let type = restArchivedInsight.insightType,
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
                period: summary.periodUnit
            )
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
                }
            )
            self = .weeklySummaryExpensesByCategory(expensesByCategory)

        case (.weeklyExpensesByDay, .weeklySummaryExpensesByDay(let weeklyExpenses)):

            let expensesByDay = ActionableInsight.WeeklyExpensesByDay(
                week: .init(year: weeklyExpenses.week.year, week: weeklyExpenses.week.week),
                expenseStatisticsByDay: weeklyExpenses.expenseStatisticsByDay.map { ActionableInsight.WeeklyExpensesByDay.ExpenseStatisticsByDay(date: $0.date, expenseStatistics: .init(totalAmount: .init(restAIAmount: $0.expenseStatistics.totalAmount), averageAmount: .init(restAIAmount: $0.expenseStatistics.averageAmount))) }
            )
            self = .weeklySummaryExpensesByDay(expensesByDay)

        case (.weeklySummaryExpenseTransactions, .weeklySummaryExpenseTransactions(let data)):
            let transactionSummary = ActionableInsight.TransactionSummary(restSummary: data.transactionSummary)
            let summary = ActionableInsight.WeeklyTransactionsSummary(week: .init(year: data.week.year, week: data.week.week), summary: transactionSummary)
            self = .weeklySummaryExpenseTransactions(summary)

        case (.monthlySummaryExpenseTransactions, .monthlySummaryExpenseTransactions(let data)):
            let transactionSummary = ActionableInsight.TransactionSummary(restSummary: data.transactionSummary)
            let summary = ActionableInsight.MonthlyTransactionsSummary(month: .init(year: data.month.year, month: data.month.month), summary: transactionSummary)
            self = .monthlySummaryExpenseTransactions(summary)

        case (.newIncomeTransaction, .newIncomeTransaction(let data)):
            self = .newIncomeTransaction(.init(transactionID: .init(data.transactionId), accountID: .init(data.accountId)))

        case (.suggestSetUpSavingsAccount, .suggestSetUpSavingsAccount(let data)):
            let data = ActionableInsight.SuggestSetUpSavingsAccount(
                balance: .init(restAIAmount: data.balance),
                savingsAccount: .init(id: .init(data.savingsAccount.accountId), name: data.savingsAccount.accountName),
                currentAccount: .init(id: .init(data.currentAccount.accountId), name: data.currentAccount.accountName)
            )

            self = .suggestSetUpSavingsAccount(data)
        case (.creditCardLimitClose, .creditCardLimitClose(let data)):
            self = .creditCardLimitClose(
                .init(
                    account: .init(
                        id: .init(data.account.accountId),
                        name: data.account.accountName
                    ),
                    availableCredit: CurrencyDenominatedAmount(restAIAmount: data.availableCredit))
            )
        case (.creditCardLimitReached, .creditCardLimitReached(let data)):
            self = .creditCardLimitReached(
                .init(
                    account: .init(
                        id: .init(data.account.accountId),
                        name: data.account.accountName
                    ),
                    availableCredit: nil
                )
            )
        case (.leftToSpendPositiveMidMonth, .leftToSpendPositiveMidMonth(let data)):
            self = .leftToSpendPositiveMidMonth(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    amountDifference: CurrencyDenominatedAmount(restAIAmount: data.amountDifference),
                    leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics(
                        createdAt: data.leftToSpendStatistics.createdAt,
                        currentLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.currentLeftToSpend),
                        averageLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.averageLeftToSpend)
                    )
                )
            )
        case (.leftToSpendNegativeMidMonth, .leftToSpendNegativeMidMonth(let data)):
            self = .leftToSpendNegativeMidMonth(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    amountDifference: CurrencyDenominatedAmount(restAIAmount: data.amountDifference),
                    leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics(
                        createdAt: data.leftToSpendStatistics.createdAt,
                        currentLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.currentLeftToSpend),
                        averageLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.averageLeftToSpend)
                    )
                )
            )
        case (.leftToSpendNegativeSummary, .leftToSpendNegativeSummary(let data)):
            self = .leftToSpendNegativeSummary(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    leftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpend))
            )
        case (.budgetSuggestCreateTopCategory, .budgetSuggestCreateTopCategory(let data)):
            self = .budgetSuggestCreateTopCategory(
                .init(
                    categorySpending: .init(
                        categoryCode: data.categorySpending.categoryCode,
                        spentAmount: CurrencyDenominatedAmount(restAIAmount: data.categorySpending.spentAmount)
                    ),
                    suggestedBudgetAmount: CurrencyDenominatedAmount(restAIAmount: data.suggestedBudgetAmount)
                )
            )
        case (.budgetSuggestCreateFirst, .budgetSuggestCreateFirst):
            self = .budgetSuggestCreateFirst
        case (.leftToSpendPositiveBeginningMonth, .leftToSpendPositiveBeginningMonth(let data)):
            self = .leftToSpendPositiveBeginningMonth(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    amountDifference: CurrencyDenominatedAmount(restAIAmount: data.amountDifference),
                    totalExpense: CurrencyDenominatedAmount(restAIAmount: data.totalExpense),
                    leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics(
                        createdAt: data.leftToSpendStatistics.createdAt,
                        currentLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.currentLeftToSpend),
                        averageLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.averageLeftToSpend)
                    )
                )
            )
        case (.leftToSpendNegativeBeginningMonth, .leftToSpendNegativeBeginningMonth(let data)):
            self = .leftToSpendNegativeBeginningMonth(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    amountDifference: CurrencyDenominatedAmount(restAIAmount: data.amountDifference),
                    totalExpense: CurrencyDenominatedAmount(restAIAmount: data.totalExpense),
                    leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics(
                        createdAt: data.leftToSpendStatistics.createdAt,
                        currentLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.currentLeftToSpend),
                        averageLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.averageLeftToSpend)
                    )
                )
            )
        case (.leftToSpendNegative, .leftToSpendNegative(let data)):
            self = .leftToSpendNegative(
                .init(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    createdAt: data.createdAt,
                    leftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpend)
                )
            )
        case (.spendingByCategoryIncreased, .spendingByCategoryIncreased(let data)):
            self = .spendingByCategoryIncreased(
                .init(
                    category: .init(id: .init(data.category.id), code: .init(data.category.code), displayName: data.category.displayName),
                    lastMonth: ActionableInsight.Month(year: data.lastMonth.year, month: data.lastMonth.month),
                    lastMonthSpending: CurrencyDenominatedAmount(restAIAmount: data.lastMonthSpending),
                    twoMonthsAgoSpending: CurrencyDenominatedAmount(restAIAmount: data.twoMonthsAgoSpending),
                    percentage: data.percentage
                )
            )
        case (.leftToSpendPositiveSummarySavingsAccount, .leftToSpendPositiveSummarySavingsAccount(let data)):
            self = .leftToSpendPositiveSummarySavingsAccount(
                ActionableInsight.LeftToSpendPositiveSummarySavingsAccount(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    leftAmount: CurrencyDenominatedAmount(restAIAmount: data.leftAmount)
                )
            )
        case (.leftToSpendPositiveFinalWeek, .leftToSpendPositiveFinalWeek(let data)):
            self = .leftToSpendPositiveFinalWeek(
                ActionableInsight.LeftToSpendPositiveFinalWeek(
                    month: ActionableInsight.Month(year: data.month.year, month: data.month.month),
                    amountDifference: CurrencyDenominatedAmount(restAIAmount: data.amountDifference),
                    leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics(
                        createdAt: data.leftToSpendStatistics.createdAt,
                        currentLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.currentLeftToSpend),
                        averageLeftToSpend: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendStatistics.averageLeftToSpend)
                    ),
                    leftToSpendPerDay: CurrencyDenominatedAmount(restAIAmount: data.leftToSpendPerDay)
                )
            )
        case (.aggregationRefreshPSD2Credentials, .aggregationRefreshPSD2Credentials(let data)):
            self = .aggregationRefreshPSD2Credentials(
                ActionableInsight.AggregationRefreshPSD2Credentials(
                    credentialsID: .init(data.credential.id),
                    provider: .init(
                        id: .init(data.credential.provider.name),
                        displayName: data.credential.provider.displayName
                    ),
                    sessionExpiryDate: data.sessionExpiryDate
                )
            )
        default:
            self = .unknown
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

extension ActionableInsight.TransactionSummary {
    init(restSummary: RESTInsightData.TransactionSummary) {
        self = .init(
            totalExpenses: .init(restAIAmount: restSummary.totalExpenses),
            commonTransactionsOverview: .init(
                totalCount: restSummary.commonTransactionsOverview.totalNumberOfTransactions,
                mostCommonDescription: restSummary.commonTransactionsOverview.mostCommonTransactionDescription,
                mostCommonCount: restSummary.commonTransactionsOverview.mostCommonTransactionCount
            ),
            largestExpense: .init(
                id: .init(restSummary.largestExpense.id),
                date: restSummary.largestExpense.date,
                amount: .init(restAIAmount: restSummary.largestExpense.amount),
                description: restSummary.largestExpense.description
            )
        )
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
            transactionsByCategory.transactionIdsByCategory.forEach { categoryDict[Category.Code($0.key)] = $0.value.transactionIds.map(Transaction.ID.init(_:)) }
            self = .viewTransactionsByCategory(categoryDict)
        case .viewAccount(let account):
            self = .viewAccount(Account.ID(account.accountId))
        case .viewLeftToSpend(let leftToSpend):
            self = .viewLeftToSpend(ActionableInsight.Month(year: leftToSpend.month.year, month: leftToSpend.month.month))
        case .createBudget(let createBudget):
            let filters = Budget.Filter.makeFilters(restFilter: createBudget.budgetSuggestion.filter)
            let amount = createBudget.budgetSuggestion.amount.flatMap(CurrencyDenominatedAmount.init(restAIAmount:))
            let periodicity = Budget.Periodicity(restPeriodicityType: createBudget.budgetSuggestion.periodicityType, restOneOffPeriodicity: createBudget.budgetSuggestion.oneOffPeriodicityData, restRecurringPeriodicity: createBudget.budgetSuggestion.recurringPeriodicityData)
            self = .createBudget(BudgetSuggestion(filters: filters, amount: amount, periodicity: periodicity))
        case .refreshCredentials(let refreshCredentials):
            self = .refreshCredentials(Credentials.ID(refreshCredentials.credentialId))
        }
    }
}
