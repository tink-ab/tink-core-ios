import Foundation

public struct ActionableInsight {
    public typealias ID = Identifier<ActionableInsight>

    public struct InsightAction {
        /// The action label
        public let label: String?

        /// The data that describes the action.
        public let data: InsightActionData?
    }

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
        case weeklyUncategorizedTransactions(WeeklyTranscations)
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
        case budgetSuggestCreateFirst
        case leftToSpendPositiveBeginningMonth(LeftToSpendBeginningMonth)
        case leftToSpendNegativeBeginningMonth(LeftToSpendBeginningMonth)
        case leftToSpendNegative(LeftToSpendNegative)
        case spendingByCategoryIncreased(SpendingByCategoryIncreased)
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

public extension ActionableInsight {
    struct AccountBalanceLowData {
        public let accountID: Account.ID
        public let balance: CurrencyDenominatedAmount

        public init(accountID: Account.ID, balance: CurrencyDenominatedAmount) {
            self.accountID = accountID
            self.balance = balance
        }
    }

    struct BudgetSummary {
        public let budgetId: Budget.ID
        public let budgetPeriod: BudgetPeriod

        public init(budgetId: Budget.ID, budgetPeriod: ActionableInsight.BudgetPeriod) {
            self.budgetId = budgetId
            self.budgetPeriod = budgetPeriod
        }
    }

    struct BudgetPeriod {
        public let dateInterval: DateInterval
        public let spentAmount: CurrencyDenominatedAmount
        public let budgetAmount: CurrencyDenominatedAmount

        public init(dateInterval: DateInterval, spentAmount: CurrencyDenominatedAmount, budgetAmount: CurrencyDenominatedAmount) {
            self.dateInterval = dateInterval
            self.spentAmount = spentAmount
            self.budgetAmount = budgetAmount
        }
    }

    struct BudgetPeriodSummary {
        public let achievedBudgets: [BudgetSummary]
        public let overspentBudgets: [BudgetSummary]
        public let period: String

        public init(achievedBudgets: [ActionableInsight.BudgetSummary], overspentBudgets: [ActionableInsight.BudgetSummary], period: String) {
            self.achievedBudgets = achievedBudgets
            self.overspentBudgets = overspentBudgets
            self.period = period
        }
    }

    struct LargeExpense {
        public let transactionID: Transaction.ID
        public let amount: CurrencyDenominatedAmount

        public init(transactionID: Transaction.ID, amount: CurrencyDenominatedAmount) {
            self.transactionID = transactionID
            self.amount = amount
        }
    }

    struct WeeklyTranscations {
        public let transactionIDs: [Transaction.ID]
        public let week: Week

        public init(transactionIDs: [Transaction.ID], week: ActionableInsight.Week) {
            self.transactionIDs = transactionIDs
            self.week = week
        }
    }

    struct CategorySpending {
        public let categoryCode: Category.Code
        public let spentAmount: CurrencyDenominatedAmount

        public init(categoryCode: Category.Code, spentAmount: CurrencyDenominatedAmount) {
            self.categoryCode = categoryCode
            self.spentAmount = spentAmount
        }
    }

    struct TransactionSummary {
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

    struct WeeklyExpensesByCategory {
        public let week: Week
        public let expensesByCategory: [CategorySpending]

        public init(week: ActionableInsight.Week, expensesByCategory: [ActionableInsight.CategorySpending]) {
            self.week = week
            self.expensesByCategory = expensesByCategory
        }
    }

    struct WeeklyExpensesByDay {
        public struct ExpenseStatisticsByDay {
            public let date: String
            public let expenseStatistics: ExpenseStatistics

            public init(date: String, expenseStatistics: ActionableInsight.WeeklyExpensesByDay.ExpenseStatistics) {
                self.date = date
                self.expenseStatistics = expenseStatistics
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

    struct WeeklyTransactionsSummary {
        public let week: Week
        public let summary: TransactionSummary

        public init(week: ActionableInsight.Week, summary: ActionableInsight.TransactionSummary) {
            self.week = week
            self.summary = summary
        }
    }

    struct MonthlyExpensesByCategory {
        public let month: Month
        public let expensesByCategory: [CategorySpending]

        public init(month: ActionableInsight.Month, expensesByCategory: [ActionableInsight.CategorySpending]) {
            self.month = month
            self.expensesByCategory = expensesByCategory
        }
    }

    struct NewIncomeTransaction {
        public let transactionID: Transaction.ID
        public let accountID: Account.ID

        public init(transactionID: Transaction.ID, accountID: Account.ID) {
            self.transactionID = transactionID
            self.accountID = accountID
        }
    }

    struct MonthlyTransactionsSummary {
        public let month: Month
        public let summary: TransactionSummary

        public init(month: ActionableInsight.Month, summary: ActionableInsight.TransactionSummary) {
            self.month = month
            self.summary = summary
        }
    }

    struct Month {
        public let year: Int
        public let month: Int

        public init(year: Int, month: Int) {
            self.year = year
            self.month = month
        }
    }

    struct Week {
        public let year: Int
        public let week: Int

        public init(year: Int, week: Int) {
            self.year = year
            self.week = week
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

    struct SuggestSetUpSavingsAccount {
        public let balance: CurrencyDenominatedAmount
        public let savingsAccount: AccountInfo
        public let currentAccount: AccountInfo

        public init(balance: CurrencyDenominatedAmount, savingsAccount: AccountInfo, currentAccount: AccountInfo) {
            self.balance = balance
            self.savingsAccount = savingsAccount
            self.currentAccount = currentAccount
        }
    }

    struct CreditCardLimit {
        public struct AccountInfo {
            public let id: TinkCore.Account.ID
            public let name: String
        }

        public let account: AccountInfo
        public let availableCredit: CurrencyDenominatedAmount?
    }

    struct LeftToSpendStatistics {
        public let createdAt: Date
        public let currentLeftToSpend: CurrencyDenominatedAmount
        public let averageLeftToSpend: CurrencyDenominatedAmount
    }

    struct LeftToSpendMidMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
    }

    struct LeftToSpendNegativeSummary {
        public let month: Month
        public let leftToSpend: CurrencyDenominatedAmount
    }

    struct BudgetSuggestCreateTopCategory {
        public let categorySpending: CategorySpending
        public let suggestedBudgetAmount: CurrencyDenominatedAmount
    }

    struct LeftToSpendBeginningMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let totalExpense: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
    }

    struct LeftToSpendNegative {
        public let month: Month
        public let createdAt: Date
        public let leftToSpend: CurrencyDenominatedAmount
    }

    struct SpendingByCategoryIncreased {
        public struct Category {
            public let id: TinkCore.Category.ID
            public let code: TinkCore.Category.Code
            public let name: String
        }

        public let category: Category
        public let lastMonth: Month
        public let lastMonthSpending: CurrencyDenominatedAmount
        public let twoMonthsAgoSpending: CurrencyDenominatedAmount
        public let percentage: Double
    }

    struct LeftToSpendPositiveSummarySavingsAccount {
        public let month: Month
        public let leftAmount: CurrencyDenominatedAmount
    }

    struct LeftToSpendPositiveFinalWeek {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
        public let leftToSpendPerDay: CurrencyDenominatedAmount
    }

    struct AggregationRefreshPSD2Credentials {
        public struct ProviderInfo {
            public let id: Provider.ID
            public let displayName: String
        }

        public let credentialsID: Credentials.ID
        public let provider: ProviderInfo
        public let sessionExpiryDate: Date
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
