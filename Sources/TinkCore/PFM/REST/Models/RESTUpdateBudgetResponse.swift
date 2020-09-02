import Foundation

typealias RESTCreateBudgetResponse = RESTBudgetResponse
typealias RESTUpdateBudgetResponse = RESTBudgetResponse

struct RESTBudgetResponse: Decodable {
    /// The created budget.
    let budgetSpecification: RESTBudget
}
