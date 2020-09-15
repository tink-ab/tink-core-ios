import Foundation

/// SignableOperation object with the status of the transfer.
public struct SignableOperation {
    /// A unique identifier of a `SignableOperation`.
    public typealias ID = Identifier<SignableOperation>

    public enum Status {
        case awaitingCredentials
        case awaitingThirdPartyAppAuthentication
        case created
        case executing
        case executed
        case failed
        case cancelled
        case unknown
    }

    public enum Kind {
        case transfer
    }

    /// The timestamp of the creation of the operation.
    public let created: Date?
    /// The ID of the Credentials used to make the operation.
    public let credentialsID: Credentials.ID?
    /// The unique identifier of this operation.
    public let id: ID?
    /// The transfer status. The value of this field changes during payment initiation according to `/resources/payments/payment-status-transitions`
    public let status: Status
    /// A message with additional information regarding the current status of the transfer.
    public let statusMessage: String?
    /// The type of operation.
    public let kind: Kind
    /// The ID of the actual transfer.
    public let transferID: Transfer.ID?
    /// The timestamp of the last update of the operation.
    public let updated: Date?
    /// The ID of the user making the operation.
    let userID: User.ID?

    /// Creates a signable operation model.
    /// - Parameters:
    ///   - created: The timestamp of the creation of the operation.
    ///   - credentialsID: The ID of the Credentials used to make the operation.
    ///   - id: The unique identifier of this operation.
    ///   - status: The transfer status.
    ///   - statusMessage: A message with additional information regarding the current status of the transfer.
    ///   - kind: The type of operation.
    ///   - transferID: The ID of the actual transfer.
    ///   - updated: The timestamp of the last update of the operation.
    ///   - userID: The ID of the user making the operation.
    public init(
        created: Date?,
        credentialsID: Credentials.ID?,
        id: SignableOperation.ID?,
        status: SignableOperation.Status,
        statusMessage: String?,
        kind: SignableOperation.Kind,
        transferID: Transfer.ID?,
        updated: Date?,
        userID: User.ID?
    ) {
        self.created = created
        self.credentialsID = credentialsID
        self.id = id
        self.status = status
        self.statusMessage = statusMessage
        self.kind = kind
        self.transferID = transferID
        self.updated = updated
        self.userID = userID
    }
}
