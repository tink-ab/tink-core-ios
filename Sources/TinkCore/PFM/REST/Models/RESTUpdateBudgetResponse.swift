import Foundation

struct RESTUpdateBudgetResponse: Decodable {
    /// The created budget.
    let budgetSpecification: RESTBudget
}

