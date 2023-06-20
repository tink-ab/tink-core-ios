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
}

extension ActionableInsight {
    public struct AccountBalanceLowData {
        public let accountID: Account.ID
        public let balance: CurrencyDenominatedAmount
    }

    public struct BudgetSummary {
        public let budgetID: Budget.ID
        public let budgetPeriod: BudgetPeriod
    }

    public struct BudgetPeriod {
        public let dateInterval: DateInterval
        public let spentAmount: CurrencyDenominatedAmount
        public let budgetAmount: CurrencyDenominatedAmount
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
    }

    public struct LargeExpense {
        public let transactionID: Transaction.ID
        public let amount: CurrencyDenominatedAmount
    }

    public struct WeeklyTransactions {
        public let transactionIDs: [Transaction.ID]
        public let week: Week
    }

    public struct CategorySpending {
        public let categoryCode: Category.Code
        public let spentAmount: CurrencyDenominatedAmount
    }

    public struct TransactionSummary {
        public struct TransactionsOverview {
            public let totalCount: Int
            public let mostCommonDescription: String
            public let mostCommonCount: Int
        }

        public struct LargestExpense {
            public let id: Transaction.ID
            public let date: Date
            public let amount: CurrencyDenominatedAmount
            public let description: String
        }

        public let totalExpenses: CurrencyDenominatedAmount
        public let commonTransactionsOverview: TransactionsOverview
        public let largestExpense: LargestExpense
    }

    public struct WeeklyExpensesByCategory {
        public let week: Week
        public let expensesByCategory: [CategorySpending]
    }

    public struct WeeklyExpensesByDay {
        public struct ExpenseStatisticsByDay {
            public let day: Day
            public let expenseStatistics: ExpenseStatistics

            init(date: [Int], expenseStatistics: ActionableInsight.WeeklyExpensesByDay.ExpenseStatistics) {
                if date.count == 3 {
                    self.day = Day(year: date[0], month: date[1], day: date[2])
                } else {
                    self.day = Day(year: 0, month: 0, day: 0)
                }
                self.expenseStatistics = expenseStatistics
            }
        }

        public struct ExpenseStatistics {
            public let totalAmount: CurrencyDenominatedAmount
            public let averageAmount: CurrencyDenominatedAmount
        }

        public let week: Week
        public let expenseStatisticsByDay: [ExpenseStatisticsByDay]
    }

    public struct WeeklyTransactionsSummary {
        public let week: Week
        public let summary: TransactionSummary
    }

    public struct MonthlyExpensesByCategory {
        public let month: Month
        public let expensesByCategory: [CategorySpending]
    }

    public struct NewIncomeTransaction {
        public let transactionID: Transaction.ID
        public let accountID: Account.ID
    }

    public struct MonthlyTransactionsSummary {
        public let month: Month
        public let summary: TransactionSummary
    }

    public struct Month {
        public let year: Int
        public let month: Int
    }

    public struct Week {
        public let year: Int
        public let week: Int
    }

    public struct Day {
        public let year: Int
        public let month: Int
        public let day: Int
    }

    public struct AccountInfo {
        public let id: Account.ID
        public let name: String
    }

    public struct SuggestSetUpSavingsAccount {
        public let balance: CurrencyDenominatedAmount
        public let savingsAccount: ActionableInsight.AccountInfo
        public let currentAccount: ActionableInsight.AccountInfo
    }

    public struct CreditCardLimit {
        public let account: AccountInfo
        public let availableCredit: CurrencyDenominatedAmount?
    }

    public struct LeftToSpendStatistics {
        public let createdAt: Date
        public let currentLeftToSpend: CurrencyDenominatedAmount
        public let averageLeftToSpend: CurrencyDenominatedAmount
    }

    public struct LeftToSpendMidMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
    }

    public struct LeftToSpendNegativeSummary {
        public let month: Month
        public let leftToSpend: CurrencyDenominatedAmount
    }

    public struct BudgetSuggestCreateTopCategory {
        public let categorySpending: CategorySpending
        public let suggestedBudgetAmount: CurrencyDenominatedAmount
        public let suggestedBudgetCategoryDisplayName: String
    }

    public struct LeftToSpendBeginningMonth {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let totalExpense: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
    }

    public struct LeftToSpendNegative {
        public let month: Month
        public let createdAt: Date
        public let leftToSpend: CurrencyDenominatedAmount
    }

    public struct CategoryInfo {
        public let id: TinkCore.Category.ID
        public let code: TinkCore.Category.Code
        public let name: String
    }

    public struct SpendingByCategoryIncreased {
        public let category: CategoryInfo
        public let lastMonth: Month
        public let lastMonthSpending: CurrencyDenominatedAmount
        public let twoMonthsAgoSpending: CurrencyDenominatedAmount
        public let percentage: Double
    }

    public struct LeftToSpendPositiveSummarySavingsAccount {
        public let month: Month
        public let leftAmount: CurrencyDenominatedAmount
    }

    public struct LeftToSpendPositiveFinalWeek {
        public let month: Month
        public let amountDifference: CurrencyDenominatedAmount
        public let leftToSpendStatistics: LeftToSpendStatistics
        public let leftToSpendPerDay: CurrencyDenominatedAmount
    }

    public struct ProviderInfo {
        public let id: Provider.ID
        public let displayName: String
    }

    public struct AggregationRefreshPSD2Credentials {
        public let credentialsID: Credentials.ID
        public let provider: ProviderInfo
        public let sessionExpiryDate: Date
    }
}

public enum InsightActionData {
    public struct ViewBudget {
        public let budgetID: Budget.ID
        public let budgetPeriodStartTime: Date
    }

    public struct CreateTransfer {
        public let sourceAccount: URL?
        public let destinationAccount: URL?
        public let amount: CurrencyDenominatedAmount?
        public let sourceAccountNumber: String?
        public let destinationAccountNumber: String?
    }

    public struct ViewTransaction {
        public let transactionID: Transaction.ID
    }

    public struct CategorizeSingleExpense {
        public let transactionID: Transaction.ID
    }

    public struct ViewTransactions {
        public let transactionIDs: [Transaction.ID]
    }

    public struct CategorizeTransactions {
        public let transactionIDs: [Transaction.ID]
    }

    public struct ViewTransactionsByCategory {
        public let transactionIdsByCategory: [Category.Code: [Transaction.ID]]
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
