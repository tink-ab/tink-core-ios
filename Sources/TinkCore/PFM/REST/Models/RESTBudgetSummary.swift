import Foundation

struct RESTBudgetSummary: Decodable {
    /** The budget. */
    let budgetSpecification: RESTBudget?
    /** The current running period. */
    let budgetPeriod: RESTBudgetPeriod?
}

struct RESTListBudgetSummariesResponse: Decodable {
    /** List of budget summaries. */
    let budgetSummaries: [RESTBudgetSummary]?
}
