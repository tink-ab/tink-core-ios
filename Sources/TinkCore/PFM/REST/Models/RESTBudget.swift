import Foundation

/// A budget represents a financial target for a defined period.
///
/// The budget itself is identified by certain filter/criteria (such as accounts, categories, tags or free-text) to target expenses. Defining multiple filter properties will yield an `AND` operation, and specifying multiple values of a filter property will yield an `OR` operation.
/// Depending on the use case a budget can either be recurring (`.week`, `.month` or `.year` or be seen as a one-off budget (fixed `start` and `end` time period).
/// The amount of the budget will relate to the recurring period defined by the periodicity unit for recurring budgets, or the fixed time window for a one-off budget.
/// A budget could for example be the goal to spend at maximum 10 euros weekly on coffee.
struct RESTBudget: Decodable {
    enum PeriodicityType: String, Decodable {
        case oneOff = "ONE_OFF"
        case recurring = "RECURRING"
    }

    struct RecurringPeriodicity: Codable {
        enum PeriodUnit: String, Codable {
            case week = "WEEK"
            case month = "MONTH"
            case year = "YEAR"
        }

        /// Recurring periodicity unit.
        let periodUnit: PeriodUnit
    }

    struct OneOffPeriodicity: Codable {
        /// Budget start expressed as UTC epoch timestamp in milliseconds.
        let start: Date
        /// Budget end expressed as UTC epoch timestamp in milliseconds.
        let end: Date
    }

    struct Filter: Codable {
        struct Account: Codable {
            /// The account ID.
            let id: String?
        }

        struct Category: Codable {
            /// The category code.
            let code: String?
        }

        struct Tag: Codable {
            /// The tag key.
            let key: String?
        }

        /// List of included accounts. Applied as logical or (union).
        let accounts: [Account]?
        /// List of included categories. Applied as logical or (union).
        let categories: [Category]?
        /// List of included tags. Applied as logical or (union).
        let tags: [Tag]?
        /// Query for a partial transaction description match.
        let freeTextQuery: String?
    }

    /// The ID of the Budget.
    let id: String?
    /// The name of the budget.
    let name: String?
    let amount: RESTCurrencyDenominatedAmount?
    /// Tells whether the budget is recurring or one off type. Using this field it's possible to see which of the field `recurringPeriodicity` or `oneOffPeriodicity` is set.
    let periodicityType: PeriodicityType?
    let recurringPeriodicity: RecurringPeriodicity?
    let oneOffPeriodicity: OneOffPeriodicity?
    /// Indicates if the budget has state archived or not.
    let archived: Bool?
    let filter: Filter?
}

struct RESTListBudgetSpecificationsResponse: Decodable {
    let budgetSpecifications: [RESTBudget]?
}
