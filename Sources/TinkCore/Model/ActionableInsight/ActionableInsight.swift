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
        case leftToSpendNegative // TODO: assume there is data here
        case weeklySummaryExpenseTransactions // TODO: assume there is data here
        case monthlySummaryExpenseTransactions // TODO: assume there is data here
        case newIncomeTransaction // TODO: assume there is data here
    }

    public let id: ID
    public let kind: Kind

    public let state: State

    public let title: String
    public let description: String
    public let created: Date


}

public extension ActionableInsight {
    struct AccountBalanceLowData {
        public let accountID: Account.ID
        public let balance: CurrencyDenominatedAmount
    }

    struct BudgetSummary {
        public let budgetId: Budget.ID
        public let budgetPeriod: BudgetPeriod
    }

    struct BudgetPeriod {
        public let dateInterval: DateInterval
        public let spentAmount: CurrencyDenominatedAmount
        public let budgetAmount: CurrencyDenominatedAmount
    }

    struct BudgetPeriodSummary {
        public let achievedBudgets: [BudgetSummary]
        public let overspentBudgets: [BudgetSummary]
        public let period: String
    }

    struct LargeExpense: Decodable {
        public let transactionID: Transaction.ID
        public let amount: CurrencyDenominatedAmount
    }

    struct WeeklyTranscations {
        public let transactionIDs: [Transaction.ID]
        public let week: Week
    }

    struct CategorySpending {
        public let categoryCode: Category.Code
        public let spentAmount: CurrencyDenominatedAmount
    }

    struct WeeklyExpensesByCategory {
        public let week: Week
        public let expensesByCategory: [CategorySpending]
    }

    struct WeeklyExpensesByDay {
        public struct ExpenseStatisticsByDay {
            public let date: String
            public let expenseStatistics: ExpenseStatistics
        }

        public struct ExpenseStatistics {
            public let totalAmount: CurrencyDenominatedAmount
            public let averageAmount: CurrencyDenominatedAmount
        }

        public let week: Week
        public let expenseStatisticsByDay: [ExpenseStatisticsByDay]
    }

    struct MonthlyExpensesByCategory {
        public let month: Month
        public let expensesByCategory: [CategorySpending]
    }

    struct Month {
        public let year: Int
        public let month: Int
    }

    struct Week {
        public let year: Int
        public let week: Int
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
}
