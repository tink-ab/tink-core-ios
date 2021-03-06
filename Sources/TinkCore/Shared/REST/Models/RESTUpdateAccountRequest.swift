import Foundation

struct RESTUpdateAccountRequest: Encodable {
    /// The internal identifier of account.
    var id: String

    /// The display name of the account. This property can be updated in a update account request.
    var name: String?

    /// The account number of the account. The format of the account numbers may differ between account types and banks. This property can be updated in a update account request.
    var accountNumber: String?

    /// The ownership ratio indicating how much of the account is owned by the user. The ownership determine the percentage of the amounts on transactions belonging to this account, that should be attributed to the user when statistics are calculated. This property has a default value, and it can only be updated by you in a update account request.
    var ownership: Double?

    /// Indicates if the user has favored the account. This property can be updated in a update account request.
    var favored: Bool?

    /// The type of the account. This property can be updated in a update account request.
    var type: RESTAccount.ModelType?

    /// Indicates features this account should be excluded from.
    /// Possible values are:
    /// `NONE`: No features are excluded from this account.
    /// `PFM_DATA`: Personal Finance Management Features, like statistics and activities are excluded.
    /// `PFM_AND_SEARCH`: Personal Finance Management Features are excluded, and transactions belonging to this account are not searchable. This is the equivalent of the, now deprecated, boolean flag `excluded`.
    /// `AGGREGATION`: No data will be aggregated for this account and, all data associated with the account is removed (except account name and account number).
    /// This property can be updated in a update account request.
    var accountExclusion: RESTAccount.AccountExclusion?
}
