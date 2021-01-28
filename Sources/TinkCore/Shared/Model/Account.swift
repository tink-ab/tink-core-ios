import Foundation

/// An account could either be a debit account, a credit card, a loan or mortgage.
public struct Account {
    /// The kind of the account.
    public enum Kind {
        /// A checking account.
        case checking
        /// A savings account.
        case savings
        /// An investment account.
        case investment
        /// A mortgage account.
        case mortgage
        /// A creditCard account.
        case creditCard
        /// A loan account.
        case loan
        /// A pension account.
        case pension
        /// Other type account.
        case other
        /// An external account.
        case external
        /// An unknown account.
        case unknown
    }

    enum Flag {
        case business
        case mandate
        case unknown
    }

    enum AccountExclusion {
        case aggregation
        case pfmAndSearch
        case pfmData
        case unknown
    }

    /// A unique identifier of an `Account`.
    public typealias ID = Identifier<Account>

    /// The account number of the account. The format of the account numbers may differ between account types and banks. This property can be updated in a update account request.
    public let accountNumber: String

    /// The current balance of the account.
    /// The definition of the balance property differs between account types.
    /// `SAVINGS`: the balance represent the actual amount of cash in the account.
    /// `INVESTMENT`: the balance represents the value of the investments connected to this accounts including any available cash.
    /// `MORTGAGE`: the balance represents the loan debt outstanding from this account.
    /// `CREDIT_CARD`: the balance represent the outstanding balance on the account, it does not include any available credit or purchasing power the user has with the credit provider.
    let balance: Double

    /// The internal identifier of the credentials that the account belongs to.
    public let credentialsID: Credentials.ID

    /// Indicates if the user has favored the account. This property can be updated in a update account request.
    public let isFavorite: Bool

    /// The internal identifier of account.
    public let id: ID

    /// The display name of the account. This property can be updated in a update account request.
    public let name: String

    /// The ownership ratio indicating how much of the account is owned by the user. The ownership determine the percentage of the amounts on transactions belonging to this account, that should be attributed to the user when statistics are calculated. This property has a default value, and it can only be updated by you in a update account request.
    let ownership: Double

    /// The type of the account. This property can be updated in a update account request.
    public let kind: Kind

    /// All possible ways to uniquely identify this `Account`; An se-identifier is built up like: se://{clearingnumber}{accountnumber};
    public let transferSourceIdentifiers: [URL]?

    /// The destinations this Account can transfer money to, be that payment or bank transfer recipients. This field is only populated if account data is requested via GET /transfer/accounts.
    let transferDestinations: [TransferDestination]?

    /// Details contains information only applicable for accounts of the types loans and mortgages.
    /// All banks do not offer detail information about their loan and mortgages therefore will details not be present on all accounts of the types loan and mortgages.
    let details: AccountDetails?

    /// The name of the account holder.
    public let holderName: String?

    /// A closed account indicates that it was no longer available from the connected financial institution, most likely due to it having been closed by the user.
    public let isClosed: Bool?

    /// A list of flags specifying attributes on an account.
    let flags: [Flag]?

    /// Indicates features this account should be excluded from.
    /// Possible values are:
    /// If `nil`, then no features are excluded from this account.
    /// `PFM_DATA`: Personal Finance Management Features, like statistics and activities are excluded.
    /// `PFM_AND_SEARCH`: Personal Finance Management Features are excluded, and transactions belonging to this account are not searchable. This is the equivalent of the, now deprecated, boolean flag `excluded`.
    /// `AGGREGATION`: No data will be aggregated for this account and, all data associated with the account is removed (except account name and account number).
    /// This property can be updated in a update account request.
    let accountExclusion: AccountExclusion?

    /// The current balance of the account.
    /// The definition of the balance property differ between account types.
    /// `SAVINGS`: the balance represent the actual amount of cash in the account.
    /// `INVESTMENT`: the balance represents the value of the investments connected to this accounts including any available cash.
    /// `MORTGAGE`: the balance represents the loan debt outstanding from this account.
    /// `CREDIT_CARD`: the balance represent the outstanding balance on the account, it does not include any available credit or purchasing power the user has with the credit provider.
    /// The balance is represented as a scale and unscaled value together with the ISO 4217 currency code of the amount.
    public let currencyDenominatedBalance: CurrencyDenominatedAmount?

    /// Timestamp of when the account was last refreshed.
    public let refreshed: Date?

    /// A unique identifier to group accounts belonging the same financial institution. Available for aggregated accounts only.
    public let financialInstitutionID: Provider.FinancialInstitution.ID?

    /// Creates an Account model.
    /// - Parameters:
    ///   - id: The internal identifier of account.
    ///   - credentialsID: The internal identifier of the credentials that the account belongs to.
    ///   - name: The display name of the account. This property can be updated in a update account request.
    ///   - accountNumber: The account number of the account.
    ///   - kind: The type of the account.
    ///   - transferSourceIdentifiers: All possible ways to uniquely identify this `Account`.
    ///   - holderName: The name of the account holder.
    ///   - isClosed: A closed account indicates that it was no longer available from the connected financial institution.
    ///   - currencyDenominatedBalance: The current balance of the account.
    ///   - refreshed: Timestamp of when the account was last refreshed.
    ///   - financialInstitutionID: A unique identifier to group accounts belonging the same financial institution.
    public init(
        id: Account.ID,
        credentialsID: Credentials.ID,
        name: String,
        accountNumber: String,
        kind: Account.Kind,
        transferSourceIdentifiers: [URL]?,
        holderName: String?,
        isClosed: Bool?,
        currencyDenominatedBalance: CurrencyDenominatedAmount?,
        refreshed: Date?,
        financialInstitutionID: Provider.FinancialInstitution.ID?
    ) {
        self.accountNumber = accountNumber
        self.balance = currencyDenominatedBalance?.doubleValue ?? 0.0
        self.credentialsID = credentialsID
        self.isFavorite = false
        self.id = id
        self.name = name
        self.ownership = 1.0
        self.kind = kind
        self.transferSourceIdentifiers = transferSourceIdentifiers
        self.transferDestinations = transferSourceIdentifiers?.map { url in
            TransferDestination(
                balance: nil,
                displayBankName: nil,
                displayAccountNumber: nil,
                uri: url,
                name: nil,
                kind: .unknown,
                isMatchingMultipleDestinations: nil
            )
        }
        self.details = nil
        self.holderName = holderName
        self.isClosed = isClosed
        self.flags = []
        self.accountExclusion = .unknown
        self.currencyDenominatedBalance = currencyDenominatedBalance
        self.refreshed = refreshed
        self.financialInstitutionID = financialInstitutionID
    }
}

// TODO: We need to look over this conformance
extension Account: Hashable {}
