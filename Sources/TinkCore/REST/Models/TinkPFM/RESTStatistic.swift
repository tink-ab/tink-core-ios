import Foundation

struct RESTStatistic: Decodable {
    let description: String
    let payload: String?
    let period: String
    let resolution: RESTStatisticQueryResolution
    let type: RESTStatisticQueryType
    let userId: String
    let value: Double
}
