import Foundation

/// The provider model represents financial institutions to where Tink can connect. It specifies how Tink accesses the financial institution, metadata about the financial institution, and what financial information that can be accessed.
public struct Provider: Identifiable {
    /// A unique identifier of a `Provider`.
    public typealias Name = Identifier<Provider>

    /// The unique identifier of the provider.
    /// - Note: This is used when creating new credentials.
    public var id: Name {
        return name
    }

    /// The unique identifier of the provider.
    /// - Note: This is used when creating new credentials.
    public let name: Name

    /// The display name of the provider.
    public let displayName: String

    /// Indicates if a user authenticates towards the provider as a person or business.
    public enum AuthenticationUserType {
        case unknown
        /// The user is authenticating as a business.
        case business
        /// The user is authenticating as a person.
        case personal
        /// The user is authenticating as a corporation.
        case corporate
    }

    @available(*, deprecated, message: "Use `financialServices` instead.")
    /// Indicates if a user authenticates toward the bank as a person or a business.
    public let authenticationUserType: AuthenticationUserType

    /// Information about financial services covered with this provider.
    public struct FinancialService: Equatable, Hashable {
        /// Indicates which segment the financial service belongs to.
        public enum Segment {
            case personal
            case business
            case unknown
        }

        /// Segment of the financial service belongs to.
        public let segment: Segment
        /// Short name of the financial service.
        public let shortName: String?
    }

    /// Financial services covered of this provider.
    public let financialServices: [FinancialService]

    /// Indicates what kind of financial institution the provider represents.
    public enum Kind {
        /// The kind of the provider is unknown.
        case unknown
        /// The provider is a bank.
        case bank
        /// The provider is a credit card.
        case creditCard
        /// The provider is a broker.
        case broker
        case other

        /// Indicates a test provider.
        case test

        public static var `default`: Set<Provider.Kind> = [.bank, .creditCard, .broker, .other]
        /// A set for the test providers kind.
        public static var onlyTest: Set<Provider.Kind> = [.test]

        /// A set of all providers kinds. Note that this also includes test providers.
        public static var all: Set<Provider.Kind> = [.unknown, .bank, .creditCard, .broker, .other, .test]
    }

    /// Indicates what kind of financial institution the provider represents.
    public let kind: Provider.Kind

    /// Indicates the release status of a provider.
    public enum ReleaseStatus {
        /// The provider is in beta and might show unexpected behavior from time to time.
        case beta
    }

    /// Indicates the release status of the provider.
    public let releaseStatus: ReleaseStatus?

    /// Indicates the current status of a provider.
    public enum Status {
        /// The status of the provider is unknown.
        case unknown
        /// The provider is enabled.
        case enabled
        /// The provider is disabled.
        case disabled
        /// The provider is temporarily disabled.
        case temporaryDisabled
    }

    /// Indicates the current status of the provider.
    /// - Note: It is only possible to perform credentials create or refresh actions on providers which are enabled.
    public let status: Status

    /// When creating a new credentials connected to the provider this will be the credential's kind.
    public let credentialsKind: Credentials.Kind

    /// Short description of how to authenticate when creating a new credentials for connected to the provider.
    public let helpText: String?

    /// Indicates if the provider is popular. This is normally set to true for the biggest financial institutions on a market.
    public let isPopular: Bool

    /// A `Field` is a representation of a specific user input field that the user will need to fill out.
    public struct Field: Equatable {
        /// A short description of what the field is used for.
        public let description: String?
        /// Gray text in the input view (Similar to a placeholder)
        public let hint: String?
        /// Maximum amount of characters accepted.
        public let maxLength: Int?
        /// Minimum amount of characters accepted.
        public let minLength: Int?
        /// Controls whether or not the field should be shown masked, like a password field.
        public let isMasked: Bool
        /// Determines if the field should only accept numeric input.
        public let isNumeric: Bool
        /// Determines if the field is immutable.
        public let isImmutable: Bool
        /// Determines if the field is optional.
        public let isOptional: Bool
        /// The name of the input field.
        public let name: String?
        /// The initial value of the field, if present.
        public let initialValue: String?
        /// A regex pattern that can be evaluated of the input.
        public let pattern: String?
        /// An error message that can be displayed if the provided pattern does not validate.
        public let patternError: String?
        /// Text displayed next to the input field.
        public let helpText: String?
    }

    /// List of fields which need to be provided when creating a credential connected to the provider.
    public let fields: [Field]

    /// The name of the group that several providers of the same bank can be placed in. Usually when a
    /// bank has branches and subsidiaries they are grouped under a single name.
    public let groupDisplayName: String

    /// A `URL` to an image representing the provider.
    public let image: URL?

    /// Short displayable description of the authentication type used.
    public let displayDescription: String

    /// Indicates what a provider is capable of.
    public struct Capabilities: OptionSet, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The provider can perform transfers.
        public static let transfers = Capabilities(rawValue: 1 << 1)
        /// The provider has mortgage aggregation.
        public static let mortgageAggregation = Capabilities(rawValue: 1 << 2)
        /// The provider can aggregate checking accounts.
        public static let checkingAccounts = Capabilities(rawValue: 1 << 3)
        /// The provider can aggregate savings accounts.
        public static let savingsAccounts = Capabilities(rawValue: 1 << 4)
        /// The provider can aggregate credit cards.
        public static let creditCards = Capabilities(rawValue: 1 << 5)
        /// The provider can aggregate investments.
        public static let investments = Capabilities(rawValue: 1 << 6)
        /// The provider can aggregate loans.
        public static let loans = Capabilities(rawValue: 1 << 7)
        /// The provider can perform payments.
        public static let payments = Capabilities(rawValue: 1 << 8)
        /// The provider can aggregate mortgage loans.
        public static let mortgageLoan = Capabilities(rawValue: 1 << 9)
        /// The provider can fetch identity data.
        public static let identityData = Capabilities(rawValue: 1 << 10)
        /// The provider can fetch e-invoice data.
        public static let eInvoices = Capabilities(rawValue: 1 << 11)
        /// The provider can list all beneficiaries.
        public static let listBeneficiaries = Capabilities(rawValue: 1 << 12)
        /// The provider can create beneficiaries.
        public static let createBeneficiaries = Capabilities(rawValue: 1 << 13)
        /// A list representing all possible capabilities.
        public static let all: Capabilities = [.transfers, .mortgageAggregation, .checkingAccounts, .savingsAccounts, .creditCards, .investments, .loans, .payments, .mortgageLoan, .identityData, .listBeneficiaries, .createBeneficiaries]
    }

    /// Indicates what this provider is capable of, in terms of financial data it can aggregate and if it can execute payments.
    public let capabilities: Capabilities

    /// What Tink uses to access data.
    public enum AccessType: Hashable {
        case unknown
        case openBanking
        case other

        /// A set of all access types.
        public static let all: Set<AccessType> = [.openBanking, .other, .unknown]
    }

    /// What Tink uses to access the data.
    public let accessType: AccessType

    /// The market of the provider.
    /// - Note: Each provider is unique per market.
    public let marketCode: String

    /// The financial institution this provider belongs to.
    public let financialInstitution: FinancialInstitution
}

extension Set where Element == Provider.Kind {
    /// A set of all providers kinds. Note that this also includes test providers.
    public static var all: Set<Provider.Kind> { Provider.Kind.all }
    /// A set of default provider kinds
    public static var `default`: Set<Provider.Kind> { Provider.Kind.default }
    /// A set of all test providers.
    public static var onlyTest: Set<Provider.Kind> { Provider.Kind.onlyTest }
}

extension Set where Element == Provider.AccessType {
    /// A set of all access types.
    public static var all: Set<Provider.AccessType> { Provider.AccessType.all }
}
