import Foundation

struct RESTArchivedInsight: Decodable {
    /// The ID of the archived insight. This is the same ID as for the corresponding insight, before it has been archived.
    let id: String?

    /// The ID of the user that the archived insight belongs to.
    let userId: String

    /// The type of the archived insight.
    let type: RESTActionableInsightType?

    /// The title of the archived insight.
    let title: String?

    /// The description of the archived insight.
    let description: String?

    let data: RESTInsightData?

    /// The epoch timestamp in UTC when the insight was created.
    let dateInsightCreated: Date?

    /// The epoch timestamp in UTC when the insight was archived.
    let dateArchived: Date?
}
