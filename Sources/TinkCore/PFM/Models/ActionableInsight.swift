import Foundation

public struct ActionableInsight {
    public typealias ID = Identifier<ActionableInsight>

    public struct InsightAction {
        /// The action label
        public let label: String?

        /// The data that describes the action.
        public let data: InsightActionData?

        public init(label: String?, data: InsightActionData?) {
            self.label = label
            self.data = data
        }
    }

    @frozen
    public enum State {
        case active([InsightAction])
        case archived(Date)
    }

    public enum Kind {
        case accountBalanceLow(AccountBalanceLowData)
        case budgetOverspent(BudgetSummary)
        case budgetCloseNegative(BudgetSummary)
        case budgetClosePositive(BudgetSummary)
        case budgetSuccess(BudgetSummary)
        case budgetSummaryAchieved(BudgetPeriodSummary)
        case budgetSummaryOverspent(BudgetPeriodSummary)
        case largeExpense(LargeExpense)
        case singleUncategorizedTransaction(Transaction.ID)
        case doubleCharge([Transaction.ID])
        case weeklyUncategorizedTransactions(WeeklyTransactions)
        case weeklySummaryExpensesByCategory(WeeklyExpensesByCategory)
        case weeklySummaryExpensesByDay(WeeklyExpensesByDay)
        case monthlySummaryExpensesByCategory(MonthlyExpensesByCategory)
        case weeklySummaryExpenseTransactions(WeeklyTransactionsSummary)
        case monthlySummaryExpenseTransactions(MonthlyTransactionsSummary)
        case newIncomeTransaction(NewIncomeTransaction)
        case suggestSetUpSavingsAccount(SuggestSetUpSavingsAccount)
        case creditCardLimitClose(CreditCardLimit)
        case creditCardLimitReached(CreditCardLimit)
        case leftToSpendPositiveMidMonth(LeftToSpendMidMonth)
        case leftToSpendNegativeMidMonth(LeftToSpendMidMonth)
        case leftToSpendNegativeSummary(LeftToSpendNegativeSummary)
        case budgetSuggestCreateTopCategory(BudgetSuggestCreateTopCategory)
        case budgetSuggestCreateTopPrimaryCategory(BudgetSuggestCreateTopCategory)
        case budgetSuggestCreateFirst
        case leftToSpendPositiveBeginningMonth(LeftToSpendBeginningMonth)
        case leftToSpendNegativeBeginningMonth(LeftToSpendBeginningMonth)
        case leftToSpendNegative(LeftToSpendNegative)
        case spendingByCategoryIncreased(SpendingByCategoryIncreased)
        case spendingByPrimaryCategoryIncreased(SpendingByCategoryIncreased)
        case leftToSpendPositiveSummarySavingsAccount(LeftToSpendPositiveSummarySavingsAccount)
        case leftToSpendPositiveFinalWeek(LeftToSpendPositiveFinalWeek)
        case aggregationRefreshPSD2Credentials(AggregationRefreshPSD2Credentials)
        case unknown
    }

    public let id: ID
    public let kind: Kind

    public let state: State

    public let title: String
    public let description: String
    public let created: Date

    public init(id: ActionableInsight.ID, kind: ActionableInsight.Kind, state: ActionableInsight.State, title: String, description: String, created: Date) {
        self.id = id
        self.kind = kind
        self.state = state
        self.title = title
        self.description = description
        self.created = created
    }
}

extension ActionableInsight {
    public struct AccountBalanceLowData {
        public let accountID: Account.ID
        public let balance: CurrencyDenominatedAmount

        public init(accountID: Account.ID, balance: CurrencyDenominatedAmount) {
            self.accountID = accountID
            self.balance = balance
        }
    }

    public struct BudgetSummary {
        public let budgetID: Budget.ID
        public let budgetPeriod: BudgetPeriod

        public init(budgetID: Budget.ID, budgetPeriod: ActionableInsight.BudgetPeriod) {
            self.budgetID = budgetID
            self.budgetPeriod = budgetPeriod
        }

        @available(*, deprecated, renamed: "budgetID")
        public var budgetId: Budget.ID { budgetID }

        @available(*, deprecated, renamed: "init(budgetID:budgetPeriod:)")
        public init(budgetId: Budget.ID, budgetPeriod: ActionableInsight.BudgetPeriod) {
            self.budgetID = budgetId
            self.budgetPeriod = budgetPeriod
        }
    }

    public struct BudgetPeriod {
        public let dateInterval: DateInterval
        public let spentAmount: CurrencyDenominatedAmount
        public let budgetAmount: CurrencyDenominatedAmount

        public init(dateInterval: DateInterval, spentAmount: CurrencyDenominatedAmount, budgetAmount: CurrencyDenominatedAmount) {
            self.dateInterval = dateInterval
            self.spentAmount = spentAmount
            self.budgetAmount = budgetAmount
        }
    }

    public enum BudgetPeriodUnit {
        case year
        case month
        case week
        case unspecified
    }

    public struct BudgetPeriodSummary {
        public let achievedBudgets: [BudgetSummary]
        public let overspentBudgets: [BudgetSummary]
        public let periodUnit: BudgetPeriodUnit

        public init(achievedBudgets: [ActionableInsight.BudgetSummary], overspentBudgets: [ActionableInsight.BudgetSummary], periodUnit: ActionableInsight.BudgetPeriodUnit) {
            self.achievedBudgets = achievedBudgets
            self.overspentBudgets = overspentBudgets
            self.periodUnit = periodUnit
        }

        @available(*, deprecated, message: "Use `periodUnit` instead.")
        public var period: String {
            switch periodUnit {
            case .year: return "YEAR"
            case .month: return "MONTH"
            case .week: return "WEEK"
            case .unspecified: return "UNSPECIFIED"
            }
        }

        @available(*, deprecated, message: "Use `init(achievedBudgets:overspentBudgets:period:)` instead")
        public init(achievedBudgets: [ActionableInsight.BudgetSummary], overspentBudgets: [ActionableInsight.BudgetSummary], period: String) {
            self.achievedBudgets = achievedBudgets
            self.overspentBudgets = overspentBudgets
            switch period {
            case "YEAR": self.periodUnit = .year
            case "MONTH": self.periodUnit = .month
            case "WEEK": self.periodUnit = .week
            case "UNSPECIFIED": self.periodUnit = .unspecified
            default: self.periodUnit = .unspecified
            }
        }
    }

    public struct LargeExpense {
        public let transactionID: Transaction.ID
        public let amount: CurrencyDenominatedAmount

        public init(transactionID: Transaction.ID, amount: CurrencyDenominatedAmount) {
            self.transactionID = transactionID
            self.amount = amount
        }
    }

    @available(*, deprecated, renamed: "WeeklyTransactions")
    public typealias WeeklyTranscations = WeeklyTransactions

    public struct WeeklyTransactions {
        public let transactionIDs: [Transaction.ID]
        public let week: Week

        public init(transactionIDs: [Transaction.ID], week: ActionableInsight.Week) {
            self.transactionIDs = transactionIDs
            self.week = week
        }
    }

    public struct CategorySpending {
        public let categoryCode: Category.Code
        public let spentAmount: CurrencyDenominatedAmount

        public init(categoryCode: Category.Code, spentAmount: CurrencyDenominatedAmount) {
            self.categoryCode = categoryCode
            self.spentAmount = spentAmount
        }
    }

    public struct TransactionSummary {
        public struct TransactionsOverview {
            public let totalCount: Int
            public let mostCommonDescription: String
            public let mostCommonCount: Int
            public init(totalCount: Int, mostCommonDescription: String, mostCommonCount: Int) {
                self.totalCount = totalCount
                self.mostCommonDescription = mostCommonDescription
                self.mostCommonCount = mostCommonCount
            }
        }

        public struct LargestExpense {
            public let id: Transaction.ID
            public let date: Date
            public let amount: CurrencyDenominatedAmount
            public let description: String

            public init(id: Transaction.ID, date: Date, amount: CurrencyDenominatedAmount, description: String) {
                self.id = id
                self.date = date
                self.amount = amount
                self.description = description
            }
        }

        public let totalExpenses: CurrencyDenominatedAmount
        public let commonTransactionsOverview: TransactionsOverview
        public let largestExpense: LargestExpense

        public init(totalExpenses: CurrencyDenominatedAmount, commonTransactionsOverview: ActionableInsight.TransactionSummary.TransactionsOverview, largestExpense: ActionableInsight.TransactionSummary.LargestExpense) {
            self.totalExpenses = totalExpenses
            self.commonTransactionsOverview = commonTransactionsOverview
            self.largestExpense = largestExpense
        }
    }

    public struct WeeklyExpensesByCategory {
        public let week: Week
        public let expensesByCategory: [CategorySpending]

        public init(week: ActionableInsight.Week, expensesByCategory: [ActionableInsight.CategorySpending]) {
            self.week = week
            self.expensesByCategory = expensesByCategory
        }
    }

    public struct WeeklyExpensesByDay {
        public struct ExpenseStatisticsByDay {
            public let day: Day
            public let expenseStatistics: ExpenseStatistics

            public init(day: ActionableInsight.Day, expenseStatistics: ActionableInsight.WeeklyExpensesByDay.ExpenseStatistics) {
                self.day = day
                self.expenseStatistics = expenseStatistics
            }

            init(date: [Int], expenseStatistics: ActionableInsight.WeeklyExpensesByDay.ExpenseStatistics) {
                if date.count == 3 {
                    self.day = Day(year: date[0], month: date[1], day: date[2])
                } else {
                    self.day = Day(year: 0, month: 0, day: 0)
                }
                self.expenseStatistics = expenseStatistics
            }

            @available(*, deprecated, message: "Use init(day:expenseStatistics:) instead.")
            public init(date: String, expenseStatistics: ActionableInsight.WeeklyExpensesByDay.ExpenseStatistics) {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
                if let parsedDate = dateFormatter.date(from: date) {
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: parsedDate)
                    self.day = Day(year: dateComponents.year ?? 0, month: dateComponents.month ?? 0, day: dateComponents.day ?? 0)
                } else {
                    self.day = Day(year: 0, month: 0, day: 0)
                }
                self.expenseStatistics = expenseStatistics
            }

            @available(*, deprecated, message: "Use day property instead.")
            public var date: String {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
                let dateComponents = DateComponents(year: day.year, month: day.month, day: day.day)
                guard let date = Calendar.current.date(from: dateComponents) else { return "" }
                return dateFormatter.string(from: date)
            }
        }

        public struct ExpenseStatistics {
            public let totalAmount: CurrencyDenominatedAmount
            public let averageAmount: CurrencyDenominatedAmount

            public init(totalAmount: CurrencyDenominatedAmount, averageAmount: CurrencyDenominatedAmount) {
                self.totalAmount = totalAmount
                self.averageAmount = averageAmount
            }
        }

        public let week: Week
        public let expenseStatisticsByDay: [ExpenseStatisticsByDay]

        public init(week: ActionableInsight.Week, expenseStatisticsByDay: [ActionableInsight.WeeklyExpensesByDay.ExpenseStatisticsByDay]) {
            self.week = week
            self.expenseStatisticsByDay = expenseStatisticsByDay
        }
    }

    public struct WeeklyTransactionsSummary {
        public let week: Week
        public let summary: TransactionSummary

        public init(week: ActionableInsight.Week, summary: ActionableInsight.TransactionSummary) {
            self.week = week
            self.summary = summary
        }
    }

    public struct MonthlyExpensesByCategory {
        public let month: Month
        public let expensesByCategory: [CategorySpending]

        public init(month: ActionableInsight.Month, expensesByCategory: [ActionableInsight.CategorySpending]) {
            self.month = month
            self.expensesByCategory = expensesByCategory
        }
    }

    public struct NewIncomeTransaction {
        public let transactionID: Transaction.ID
        public let accountID: Account.ID

        public init(transactionID: Transaction.ID, accountID: Account.ID) {
            self.transactionID = transactionID
            self.accountID = accountID
        }
    }

    public struct MonthlyTransactionsSummary {
        public let month: Month
        public let summary: TransactionSummary

        public init(month: ActionableInsight.Month, summary: ActionableInsight.TransactionSummary) {
            self.month = month
            self.summary = summary
        }
    }

    public struct Month {
        public let year: Int
        public let month: Int

        public init(year: Int, month: Int) {
            self.year = year
            self.month = month
        }
    }

    public struct Week {
        public let year: Int
        public let week: Int

        public init(year: Int, week: Int) {
            self.year = year
            self.week = week
        }
    }

    public struct Day {
        public let year: Int
        public let month: Int
        public let day: Int

        public init(year: Int, month: Int, day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
    }

    public struct AccountInfo {
        public let id: Account.ID
        public let name: String

        public init(id: Account.ID, name: String) {
            self.id = id
            self.name = name
        }
    }

    public struct SuggestSetUpSavingsAccount {
        @available(*, deprecated, message: "Use ActionableInsight.AccountInfo instead.")
        public typealias AccountInfo = ActionableInsight.AccountInfo

        public let balance: CurrencyDenominatedAmount
        public let savingsAccount: ActionableInsight.AccountInfo
        public let currentAccount: ActionableInsight.AccountInfo

        public init(balance: CurrencyDenominatedAmount, savingsAccount: ActionableInsight.AccountInfo, currentAccount: ActionableInsight.AccountInfo) {
            self.balance = balance
            self.savingsAccount = savingsAccount
            self.currentAccount = currentAccount
        }
    }

    public struct CreditCardLimit {
        public let account: AccountInfo
        public let availableCredit: CurrencyDenominatedAmount?

        public init(account: ActionableInsight.AccountInfo, availableCredit: CurrencyDenominatedAmount?) {
            self.account = account
            self.availableCredit = availableCredit
        }
    }

    public struct LeftToSpendStatistics {
        public let createdAt: Date
        public let currentLeftToSpend: CurrencyDenominatedAmount
        public let averageLeftToSpend: CurrencyDenominatedAmount

        public init(createdAt: Date, currentLeftToSpend: CurrencyDenominatedAmount, averageLeftToSpend: CurrencyDenominatedAmount) {
            self.createdAt = createdAt
            self.currentLeftToSpend = currentLeftToSpend
            self.averageLeftToSpend = averageLeftToSpend
        }
    }

    public struct LeftToSpendMidMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics

        public init(month: ActionableInsight.Month, amountDifference: CurrencyDenominatedAmount, leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics) {
            self.month = month
            self.amountDifference = amountDifference
            self.leftToSpendStatistics = leftToSpendStatistics
        }
    }

    public struct LeftToSpendNegativeSummary {
        public let month: Month
        public let leftToSpend: CurrencyDenominatedAmount

        public init(month: ActionableInsight.Month, leftToSpend: CurrencyDenominatedAmount) {
            self.month = month
            self.leftToSpend = leftToSpend
        }
    }

    public struct BudgetSuggestCreateTopCategory {
        public let categorySpending: CategorySpending
        public let suggestedBudgetAmount: CurrencyDenominatedAmount
        public let suggestedBudgetCategoryDisplayName: String

        public init(categorySpending: ActionableInsight.CategorySpending, suggestedBudgetAmount: CurrencyDenominatedAmount, suggestedBudgetCategoryDisplayName: String = "") {
            self.categorySpending = categorySpending
            self.suggestedBudgetAmount = suggestedBudgetAmount
            self.suggestedBudgetCategoryDisplayName = suggestedBudgetCategoryDisplayName
        }
    }

    public struct LeftToSpendBeginningMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let totalExpense: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics

        public init(month: ActionableInsight.Month, amountDifference: CurrencyDenominatedAmount, totalExpense: CurrencyDenominatedAmount, leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics) {
            self.month = month
            self.amountDifference = amountDifference
            self.totalExpense = totalExpense
            self.leftToSpendStatistics = leftToSpendStatistics
        }
    }

    public struct LeftToSpendNegative {
        public let month: Month
        public let createdAt: Date
        public let leftToSpend: CurrencyDenominatedAmount

        public init(month: ActionableInsight.Month, createdAt: Date, leftToSpend: CurrencyDenominatedAmount) {
            self.month = month
            self.createdAt = createdAt
            self.leftToSpend = leftToSpend
        }
    }

    public struct CategoryInfo {
        public let id: TinkCore.Category.ID
        public let code: TinkCore.Category.Code
        public let name: String

        public init(id: Category.ID, code: Category.Code, name: String) {
            self.id = id
            self.code = code
            self.name = name
        }
    }

    public struct SpendingByCategoryIncreased {
        public let category: CategoryInfo
        public let lastMonth: Month
        public let lastMonthSpending: CurrencyDenominatedAmount
        public let twoMonthsAgoSpending: CurrencyDenominatedAmount
        public let percentage: Double

        public init(category: ActionableInsight.CategoryInfo, lastMonth: ActionableInsight.Month, lastMonthSpending: CurrencyDenominatedAmount, twoMonthsAgoSpending: CurrencyDenominatedAmount, percentage: Double) {
            self.category = category
            self.lastMonth = lastMonth
            self.lastMonthSpending = lastMonthSpending
            self.twoMonthsAgoSpending = twoMonthsAgoSpending
            self.percentage = percentage
        }
    }

    public struct LeftToSpendPositiveSummarySavingsAccount {
        public let month: Month
        public let leftAmount: CurrencyDenominatedAmount

        public init(month: ActionableInsight.Month, leftAmount: CurrencyDenominatedAmount) {
            self.month = month
            self.leftAmount = leftAmount
        }
    }

    public struct LeftToSpendPositiveFinalWeek {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
        public let leftToSpendPerDay: CurrencyDenominatedAmount

        public init(month: ActionableInsight.Month, amountDifference: CurrencyDenominatedAmount, leftToSpendStatistics: ActionableInsight.LeftToSpendStatistics, leftToSpendPerDay: CurrencyDenominatedAmount) {
            self.month = month
            self.amountDifference = amountDifference
            self.leftToSpendStatistics = leftToSpendStatistics
            self.leftToSpendPerDay = leftToSpendPerDay
        }
    }

    public struct ProviderInfo {
        public let id: Provider.ID
        public let displayName: String

        public init(id: Provider.ID, displayName: String) {
            self.id = id
            self.displayName = displayName
        }
    }

    public struct AggregationRefreshPSD2Credentials {
        public let credentialsID: Credentials.ID
        public let provider: ProviderInfo
        public let sessionExpiryDate: Date

        public init(credentialsID: Credentials.ID, provider: ActionableInsight.ProviderInfo, sessionExpiryDate: Date) {
            self.credentialsID = credentialsID
            self.provider = provider
            self.sessionExpiryDate = sessionExpiryDate
        }
    }
}

public enum InsightActionData {
    public struct ViewBudget {
        public let budgetID: Budget.ID
        public let budgetPeriodStartTime: Date

        public init(budgetID: Budget.ID, budgetPeriodStartTime: Date) {
            self.budgetID = budgetID
            self.budgetPeriodStartTime = budgetPeriodStartTime
        }
    }

    public struct CreateTransfer {
        public let sourceAccount: URL?
        public let destinationAccount: URL?
        public let amount: CurrencyDenominatedAmount?

        public init(sourceAccount: URL?, destinationAccount: URL?, amount: CurrencyDenominatedAmount?) {
            self.sourceAccount = sourceAccount
            self.destinationAccount = destinationAccount
            self.amount = amount
        }
    }

    public struct ViewTransaction {
        public let transactionID: Transaction.ID

        public init(transactionID: Transaction.ID) {
            self.transactionID = transactionID
        }
    }

    public struct CategorizeSingleExpense {
        public let transactionID: Transaction.ID

        public init(transactionID: Transaction.ID) {
            self.transactionID = transactionID
        }
    }

    public struct ViewTransactions {
        public let transactionIDs: [Transaction.ID]

        public init(transactionIDs: [Transaction.ID]) {
            self.transactionIDs = transactionIDs
        }
    }

    public struct CategorizeTransactions {
        public let transactionIDs: [Transaction.ID]

        public init(transactionIDs: [Transaction.ID]) {
            self.transactionIDs = transactionIDs
        }
    }

    public struct ViewTransactionsByCategory {
        public let transactionIdsByCategory: [Category.Code: [Transaction.ID]]

        public init(transactionIdsByCategory: [Category.Code: [Transaction.ID]]) {
            self.transactionIdsByCategory = transactionIdsByCategory
        }
    }

    public struct BudgetSuggestion {
        public let filters: [Budget.Filter]
        public let amount: CurrencyDenominatedAmount?
        public let periodicity: Budget.Periodicity?

        public init(filters: [Budget.Filter], amount: CurrencyDenominatedAmount?, periodicity: Budget.Periodicity?) {
            self.filters = filters
            self.amount = amount
            self.periodicity = periodicity
        }
    }

    case unknown
    case acknowledge
    case dismiss
    case viewBudget(ViewBudget)
    case createTransfer(CreateTransfer)
    case viewTransaction(Transaction.ID)
    case categorizeExpense(Transaction.ID)
    case viewTransactions([Transaction.ID])
    case categorizeTransactions([Transaction.ID])
    case viewTransactionsByCategory([Category.Code: [Transaction.ID]])
    case viewAccount(Account.ID)
    case viewLeftToSpend(ActionableInsight.Month)
    case createBudget(BudgetSuggestion)
    case refreshCredentials(Credentials.ID)
}
