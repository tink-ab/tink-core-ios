import Foundation

/// An actionable insight represent some kind of actionable event or insight derived from user data.
///
/// It could for instance be that a user has low balance on one of their bank accounts where the action could be to transfer money to that account.
/// Another example could be to encourage a user to save more money by creating a budget for a specific category.
struct RESTActionableInsight: Decodable {
    /// The unique identifier of the insight.
    let id: String?

    /// The unique identifier of the user that the insight belongs to.
    let userId: String

    /// Conveys the meaning of the Insight. The type will also indicate the structure of the data field
    let type: RESTActionableInsightType?

    /// The title of the insight which can be shown to the user.
    let title: String?

    /// The description of the insight which can be shown to the user.
    let description: String?

    /// The data that describes the basis for why this Insight was created.
    let data: RESTInsightData?

    /// The epoch timestamp in UTC when the insight was created.
    let createdTime: Date?

    /// A list of proposed actions that the user can take in response to the insight.
    let insightActions: [RESTInsightProposedAction]?
}

// Mapping from type string to enum. Values defined on backend here: https://github.com/tink-ab/tink-backend/blob/master/src/insights/lib/src/main/java/se/tink/backend/insights/core/valueobjects/InsightType.java
enum RESTActionableInsightType: String, Decodable, DefaultableDecodable {
    static var decodeFallbackValue: RESTActionableInsightType = .unknown

    case unknown
    case accountBalanceLow = "ACCOUNT_BALANCE_LOW"
    case budgetOverspent = "BUDGET_OVERSPENT"
    case budgetCloseNegative = "BUDGET_CLOSE_NEGATIVE"
    case budgetClosePositive = "BUDGET_CLOSE_POSITIVE"
    case budgetSuccess = "BUDGET_SUCCESS"
    case budgetSummaryAchieved = "BUDGET_SUMMARY_ACHIEVED"
    case budgetSummaryOverspent = "BUDGET_SUMMARY_OVERSPENT"
    case largeExpense = "LARGE_EXPENSE"
    case singleUncategorizedTransaction = "SINGLE_UNCATEGORIZED_TRANSACTION"
    case doubleCharge = "DOUBLE_CHARGE"
    case weeklyUncategorizedTransactions = "WEEKLY_UNCATEGORIZED_TRANSACTIONS"
    case weeklySummaryExpensesByCategory = "WEEKLY_SUMMARY_EXPENSES_BY_CATEGORY"
    case weeklyExpensesByDay = "WEEKLY_SUMMARY_EXPENSES_BY_DAY"
    case monthlySummaryExpensesByCategory = "MONTHLY_SUMMARY_EXPENSES_BY_CATEGORY"
    case weeklySummaryExpenseTransactions = "WEEKLY_SUMMARY_EXPENSE_TRANSACTIONS"
    case monthlySummaryExpenseTransactions = "MONTHLY_SUMMARY_EXPENSE_TRANSACTIONS"
    case newIncomeTransaction = "NEW_INCOME_TRANSACTION"
    case suggestSetUpSavingsAccount = "SUGGEST_SET_UP_SAVINGS_ACCOUNT"
}

enum RESTInsightData: Decodable {
    struct CurrencyDenominatedAmount: Decodable {
        let amount: Double
        let currencyCode: String
    }

    struct AccountBalanceLow: Decodable {
        let accountId: String
        let balance: RESTInsightData.CurrencyDenominatedAmount
    }

    struct BudgetSummary: Decodable {
        let budgetId: String
        let budgetPeriod: RESTInsightData.BudgetPeriod
    }

    struct BudgetPeriod: Decodable {
        let start: Date
        let end: Date
        let spentAmount: RESTInsightData.CurrencyDenominatedAmount
        let budgetAmount: RESTInsightData.CurrencyDenominatedAmount
    }

    struct BudgetSummaryArchived: Decodable {
        let achievedBudgets: [RESTInsightData.BudgetSummary]
        let overspentBudgets: [RESTInsightData.BudgetSummary]
        let periodUnit: String
    }

    struct BudgetSummaryOverspent: Decodable {
        let achievedBudgets: [RESTInsightData.BudgetSummary]
        let overspentBudgets: [RESTInsightData.BudgetSummary]
        let periodUnit: String
    }

    struct LargeExpense: Decodable {
        let transactionId: String
        let amount: RESTInsightData.CurrencyDenominatedAmount
    }

    struct Transaction: Decodable {
        let transactionId: String
    }

    struct Week: Decodable {
        let year: Int
        let week: Int
    }

    struct Month: Decodable {
        let year: Int
        let month: Int
    }

    struct DoubleCharge: Decodable {
        let transactionIds: [String]
    }

    struct WeeklyUncategorizedTransactions: Decodable {
        let transactionIds: [String]
        let week: RESTInsightData.Week
    }

    struct WeeklyExpensesByCategory: Decodable {
        struct CategorySpending: Decodable {
            let categoryCode: String
            let spentAmount: RESTInsightData.CurrencyDenominatedAmount
        }

        let week: RESTInsightData.Week
        let expensesByCategory: [CategorySpending]
    }

    struct WeeklyExpensesByDay: Decodable {
        struct ExpenseStatisticsByDay: Decodable {
            let date: String
            let expenseStatistics: ExpenseStatistics
        }

        struct ExpenseStatistics: Decodable {
            let totalAmount: RESTInsightData.CurrencyDenominatedAmount
            let averageAmount: RESTInsightData.CurrencyDenominatedAmount
        }

        let week: RESTInsightData.Week
        let expenseStatisticsByDay: [ExpenseStatisticsByDay]
    }

    struct TransactionSummary: Decodable {
        struct Overview: Decodable {
            let totalNumberOfTransactions: Int
            let mostCommonTransactionDescription: String
            let mostCommonTransactionCount: Int
        }

        struct LargestExpense: Decodable {
            let id: String
            let date: Date
            let amount: RESTInsightData.CurrencyDenominatedAmount
            let description: String
        }

        let totalExpenses: CurrencyDenominatedAmount
        let commonTransactionsOverview: Overview
        let largestExpense: LargestExpense
    }

    struct WeeklySummaryExpenseTransactions: Decodable {
        let week: RESTInsightData.Week
        let transactionSummary: TransactionSummary
    }

    struct MonthlyExpensesByCategory: Decodable {
        struct CategorySpending: Decodable {
            let categoryCode: String
            let spentAmount: RESTInsightData.CurrencyDenominatedAmount
        }

        let month: RESTInsightData.Month
        let expensesByCategory: [CategorySpending]
    }

    struct MonthlySummaryExpenseTransactions: Decodable {
        let month: RESTInsightData.Month
        let transactionSummary: TransactionSummary
    }

    struct NewIncomeTransaction: Decodable {
        let transactionId: String
        let accountId: String
    }

    struct SuggestSetUpSavingsAccount: Decodable {
        struct Account: Decodable {
            let accountId: String
            let accountName: String
        }

        let balance: CurrencyDenominatedAmount
        let savingsAccount: Account
        let currentAccount: Account
    }

    case unknown
    case accountBalanceLow(AccountBalanceLow)
    case budgetOverspent(BudgetSummary)
    case budgetCloseNegative(BudgetSummary)
    case budgetClosePositive(BudgetSummary)
    case budgetSuccess(BudgetSummary)
    case budgetSummaryAchieved(BudgetSummaryArchived)
    case budgetSummaryOverspent(BudgetSummaryOverspent)
    case largeExpense(LargeExpense)
    case singleUncategorizedTransaction(Transaction)
    case doubleCharge(DoubleCharge)
    case weeklyUncategorizedTransactions(WeeklyUncategorizedTransactions)
    case weeklySummaryExpensesByCategory(WeeklyExpensesByCategory)
    case weeklySummaryExpensesByDay(WeeklyExpensesByDay)
    case weeklySummaryExpenseTransactions(WeeklySummaryExpenseTransactions)
    case monthlySummaryExpensesByCategory(MonthlyExpensesByCategory)
    case monthlySummaryExpenseTransactions(MonthlySummaryExpenseTransactions)
    case newIncomeTransaction(NewIncomeTransaction)
    case suggestSetUpSavingsAccount(SuggestSetUpSavingsAccount)

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            let type = try container.decode(RESTActionableInsightType.self, forKey: .type)

            switch type {
            case .accountBalanceLow:
                let data = try AccountBalanceLow(from: decoder)
                self = .accountBalanceLow(data)
            case .budgetOverspent:
                let data = try BudgetSummary(from: decoder)
                self = .budgetOverspent(data)
            case .budgetCloseNegative:
                let data = try BudgetSummary(from: decoder)
                self = .budgetCloseNegative(data)
            case .budgetClosePositive:
                let data = try BudgetSummary(from: decoder)
                self = .budgetClosePositive(data)
            case .budgetSuccess:
                let data = try BudgetSummary(from: decoder)
                self = .budgetSuccess(data)
            case .budgetSummaryAchieved:
                let data = try BudgetSummaryArchived(from: decoder)
                self = .budgetSummaryAchieved(data)
            case .budgetSummaryOverspent:
                let data = try BudgetSummaryOverspent(from: decoder)
                self = .budgetSummaryOverspent(data)
            case .largeExpense:
                let data = try LargeExpense(from: decoder)
                self = .largeExpense(data)
            case .singleUncategorizedTransaction:
                let data = try Transaction(from: decoder)
                self = .singleUncategorizedTransaction(data)
            case .doubleCharge:
                let data = try DoubleCharge(from: decoder)
                self = .doubleCharge(data)
            case .weeklyUncategorizedTransactions:
                let data = try WeeklyUncategorizedTransactions(from: decoder)
                self = .weeklyUncategorizedTransactions(data)
            case .weeklySummaryExpensesByCategory:
                let data = try WeeklyExpensesByCategory(from: decoder)
                self = .weeklySummaryExpensesByCategory(data)
            case .weeklyExpensesByDay:
                let data = try WeeklyExpensesByDay(from: decoder)
                self = .weeklySummaryExpensesByDay(data)
            case .monthlySummaryExpensesByCategory:
                let data = try MonthlyExpensesByCategory(from: decoder)
                self = .monthlySummaryExpensesByCategory(data)
            case .monthlySummaryExpenseTransactions:
                let data = try MonthlyExpensesByCategory(from: decoder)
                self = .monthlySummaryExpensesByCategory(data)
            case .weeklySummaryExpenseTransactions:
                let data = try WeeklySummaryExpenseTransactions(from: decoder)
                self = .weeklySummaryExpenseTransactions(data)
            case .newIncomeTransaction:
                let data = try NewIncomeTransaction(from: decoder)
                self = .newIncomeTransaction(data)
            case .suggestSetUpSavingsAccount:
                let data = try SuggestSetUpSavingsAccount(from: decoder)
                self = .suggestSetUpSavingsAccount(data)
            case .unknown:
                self = .unknown
            }
        } catch {
            self = .unknown
        }
    }
}

struct RESTInsightProposedAction: Decodable {
    /// The action label
    let label: String?

    /// The data that describes the action.
    let data: RESTInsightActionData?
}

enum RESTInsightActionDataType: String, Decodable {
    case unknown
    case acknowledge = "ACKNOWLEDGE"
    case dismiss = "DISMISS"
    case viewBudget = "VIEW_BUDGET"
    case createTransfer = "CREATE_TRANSFER"
    case viewTransaction = "VIEW_TRANSACTION"
    case categorizeExpense = "CATEGORIZE_EXPENSE"
    case viewTransactions = "VIEW_TRANSACTIONS"
    case categorizeTransactions = "CATEGORIZE_TRANSACTIONS"
    case viewTransactionsByCategory = "VIEW_TRANSACTIONS_BY_CATEGORY"
    case viewAccount = "VIEW_ACCOUNT"
    case viewLeftToSpend = "VIEW_LEFT_TO_SPEND"
    case createBudget = "CREATE_BUDGET"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = RESTInsightActionDataType(rawValue: rawValue) ?? .unknown
    }
}

enum RESTInsightActionData: Decodable {
    struct ViewBudget: Decodable {
        let budgetId: String
        let budgetPeriodStartTime: Date
    }

    struct CreateTransfer: Decodable {
        let sourceAccount: URL?
        let destinationAccount: URL?
        let amount: RESTInsightData.CurrencyDenominatedAmount?
    }

    struct ViewTransaction: Decodable {
        let transactionId: String
    }

    struct CategorizeSingleExpense: Decodable {
        let transactionId: String
    }

    struct ViewTransactions: Decodable {
        let transactionIds: [String]
    }

    struct CategorizeTransactions: Decodable {
        let transactionIds: [String]
    }

    struct ViewTransactionsByCategory: Decodable {
        let transactionIdsByCategory: [String: RESTInsightActionData.ViewTransactions]
    }

    struct ViewAccount: Decodable {
        let accountId: String
    }

    struct ViewLeftToSpend: Decodable {
        let month: RESTInsightData.Month
    }

    struct CreateBudget: Decodable {
        struct BudgetSuggestion: Decodable {
            let filter: RESTBudget.Filter?
            let amount: RESTCurrencyDenominatedAmount?
            let periodicityType: RESTBudget.PeriodicityType?
            let recurringPeriodicityData: RESTBudget.RecurringPeriodicity?
        }
        let budgetSuggestion: BudgetSuggestion
    }

    case unknown
    case acknowledge
    case dismiss
    case viewBudget(ViewBudget)
    case createTransfer(CreateTransfer)
    case viewTransaction(ViewTransaction)
    case categorizeExpense(CategorizeSingleExpense)
    case viewTransactions(ViewTransactions)
    case categorizeTransactions(CategorizeTransactions)
    case viewTransactionsByCategory(ViewTransactionsByCategory)
    case viewAccount(ViewAccount)
    case viewLeftToSpend(ViewLeftToSpend)
    case createBudget(CreateBudget)

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            let type = try container.decode(RESTInsightActionDataType.self, forKey: .type)

            switch type {
            case .unknown:
                self = .unknown
            case .acknowledge:
                self = .acknowledge
            case .dismiss:
                self = .dismiss
            case .viewBudget:
                let data = try ViewBudget(from: decoder)
                self = .viewBudget(data)
            case .createTransfer:
                let data = try CreateTransfer(from: decoder)
                self = .createTransfer(data)
            case .viewTransaction:
                let data = try ViewTransaction(from: decoder)
                self = .viewTransaction(data)
            case .categorizeExpense:
                let data = try CategorizeSingleExpense(from: decoder)
                self = .categorizeExpense(data)
            case .viewTransactions:
                let data = try ViewTransactions(from: decoder)
                self = .viewTransactions(data)
            case .categorizeTransactions:
                let data = try CategorizeTransactions(from: decoder)
                self = .categorizeTransactions(data)
            case .viewTransactionsByCategory:
                let data = try ViewTransactionsByCategory(from: decoder)
                self = .viewTransactionsByCategory(data)
            case .viewAccount:
                let data = try ViewAccount(from: decoder)
                self = .viewAccount(data)
            case .viewLeftToSpend:
                let data = try ViewLeftToSpend(from: decoder)
                self = .viewLeftToSpend(data)
            case .createBudget:
                let data = try CreateBudget(from: decoder)
                self = .createBudget(data)
            }
        } catch {
            self = .unknown
        }
    }
}
