import Foundation

struct RESTArchiveBudgetResponse: Decodable {
    /// The archived budget.
    let budgetSpecification: RESTBudget
}

