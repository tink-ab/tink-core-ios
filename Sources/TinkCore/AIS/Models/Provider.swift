import Foundation

/// The provider model represents financial institutions to where Tink can connect. It specifies how Tink accesses the financial institution, metadata about the financialinstitution, and what financial information that can be accessed.
public struct Provider: Identifiable {
    /// A unique identifier of a `Provider`.
    public typealias ID = Identifier<Provider>

    /// The unique identifier of the provider.
    /// - Note: This is used when creating new credentials.
    public let id: ID

    /// The display name of the provider.
    public let displayName: String

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
        case fraud

        /// The provider is a business bank.
        case businessBank
        case firstParty

        public static var `default`: Set<Provider.Kind> = [.bank, .creditCard, .broker, .other]
        @available(*, deprecated, renamed: "default")
        public static var defaultKinds: Set<Provider.Kind> = [.bank, .creditCard, .broker, .other]
        /// A set for the test providers kind.
        public static var onlyTest: Set<Provider.Kind> = [.test]
        @available(*, deprecated)
        public static var excludingTest: Set<Provider.Kind> = [.unknown, .bank, .creditCard, .broker, .other, .fraud]

        /// A set of all providers kinds. Note that this also includes test providers.
        public static var all: Set<Provider.Kind> = [.unknown, .bank, .creditCard, .broker, .other, .test, .fraud]
    }

    /// Indicates what kind of financial institution the provider represents.
    public let kind: Provider.Kind

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
        /// The provider is obsolute.
        case obsolete
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

    public struct FieldSpecification {
        // description
        public let fieldDescription: String
        /// Gray text in the input view (Similar to a placeholder)
        public let hint: String
        public let maxLength: Int?
        public let minLength: Int?
        /// Controls whether or not the field should be shown masked, like a password field.
        public let isMasked: Bool
        public let isNumeric: Bool
        public let isImmutable: Bool
        public let isOptional: Bool
        public let name: String
        public let initialValue: String
        public let pattern: String
        public let patternError: String
        /// Text displayed next to the input field
        public let helpText: String

        public mutating func setImmutable(initialValue newValue: String) {
            self = .init(
                fieldDescription: fieldDescription,
                hint: hint,
                maxLength: maxLength,
                minLength: minLength,
                isMasked: isMasked,
                isNumeric: isNumeric,
                isImmutable: true,
                isOptional: isOptional,
                name: name,
                initialValue: newValue,
                pattern: pattern,
                patternError: patternError,
                helpText: helpText
            )
        }
    }

    public let fields: [FieldSpecification]

    /// A display name for providers which are branches of a bigger group.
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
        /// The provider can aggregate checkings accounts.
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
        /// The provider can creat beneficiaries.
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

    /// The financial institution.
    public let financialInstitution: FinancialInstitution
}

public extension Set where Element == Provider.Kind {
    /// A set of all providers kinds. Note that this also includes test providers.
    static var all: Set<Provider.Kind> { Provider.Kind.all }
    /// A set of default provider kinds
    static var `default`: Set<Provider.Kind> { Provider.Kind.default }
    /// A set of default provider kinds
    @available(*, deprecated, renamed: "default")
    static var defaultKinds: Set<Provider.Kind> = [.bank, .creditCard, .broker, .other]
    /// A set of all test providers.
    static var onlyTest: Set<Provider.Kind> { Provider.Kind.onlyTest }
}

public extension Set where Element == Provider.AccessType {
    /// A set of all access types.
    static var all: Set<Provider.AccessType> { Provider.AccessType.all }
}
