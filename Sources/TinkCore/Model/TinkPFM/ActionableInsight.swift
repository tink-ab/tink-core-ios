import Foundation
import UIKit

/// An actionable insight represent some kind of actionable event or insight derived from user data.
///
/// It could for instance be that a user has low balance on one of their bank accounts where the action could be to transfer money to that account.
/// Another example could be to encourage a user to save more money by creating a budget for a specific category.
public struct ActionableInsight {
    typealias ID = Identifier<ActionableInsight>

    public struct Insight {
        var title: String
        var detail: String

        enum Illustration {
            case icon(Icon)
            case image(UIImage)
            case budget(Budget.ID)
            case transactions([Transaction.ID])
            case budgetSummary(BudgetSummary)
            case periodSummaryExpensesByCategory(PeriodSummaryExpensesByCategory)
            case weeklySummaryExpensesByDay(WeeklySummaryExpensesByDay)
        }

        var illustration: Illustration
        var color: UIColor

        public enum DataType {
            case unknown
            case accountBalanceLow
            case budgetOverspent
            case budgetCloseNegative
            case budgetClosePositive
            case budgetSuccess
            case budgetSummaryAchieved
            case budgetSummaryOverspent
            case largeExpense
            case singleUncategorizedTransaction
            case doubleCharge
            case weeklyUncategorizedTransactions
            case weeklySummaryExpensesByCategory
            case weeklySummaryExpensesByDay
            case monthlySummaryExpensesByCategory
        }

        var dataType: DataType
    }

    struct Action {
        var title: String
        var isPrimary: Bool

        var target: Target

        enum Target {
            struct ViewBudget: Decodable {
                let budgetId: Budget.ID
                let budgetPeriodStartTime: Date
            }

            struct CreateTransfer: Decodable {
                let sourceAccount: URL?
                let destinationAccount: URL?
                let amount: CurrencyDenominatedAmount?
            }

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
    }
    
    /// The unique identifier of the user that the insight belongs to.
    let id: ID?

    var insight: Insight

    var actions: [Action]

    var performedAction: Date?
}
