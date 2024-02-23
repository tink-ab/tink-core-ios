import Foundation

/// Access to Tink is divided into scopes which grant access to different API endpoints.
/// Each API customer has a set of scopes which control the maximum permitted data access.
/// To see the total set of scopes that you can use, go to app settings in the Tink Console.
public struct Scope {
    /// The name of the data the scope is for.
    let name: String
    /// A set of access strings this scope have, for example `"read"` or `"write"`.
    let access: [String]
}

extension Scope {
    var scopeDescription: String {
        access.map { "\(name):\($0)" }.joined(separator: ",")
    }
}

extension Scope: Equatable {}

extension Array where Element == Scope {
    var scopeDescription: String { map(\.scopeDescription).joined(separator: ",") }
}

extension Scope {
    public enum ReadAccess: String {
        case read
    }

    public enum ReadWriteAccess: String {
        case read, write
    }

    public enum AuthorizationAccess: String {
        case grant, read, revoke
    }

    public enum CredentialsAccess: String {
        case read, write, refresh
    }

    public enum TransactionAccess: String {
        case read, write, categorize
    }

    public enum TransferAccess: String {
        case read, execute
    }

    public enum UserAccess: String {
        case create, delete, read, webHooks = "web_hooks", write
    }

    /// Access to all the user's account information.
    public static func accounts(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "accounts", access: access.map(\.rawValue))
    }

    public static func activities(_ access: ReadAccess...) -> Scope {
        return Scope(name: "activities", access: access.map(\.rawValue))
    }

    public static func authorization(_ access: AuthorizationAccess...) -> Scope {
        return Scope(name: "authorization", access: access.map(\.rawValue))
    }

    /// Access to accounts' balances data.
    public static func balances(_ access: ReadAccess...) -> Scope {
        return Scope(name: "balances", access: access.map(\.rawValue))
    }

    public static func beneficiaries(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "beneficiaries", access: access.map(\.rawValue))
    }

    public static func budgets(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "budgets", access: access.map(\.rawValue))
    }

    public static func calendar(_ access: ReadAccess...) -> Scope {
        return Scope(name: "calendar", access: access.map(\.rawValue))
    }

    public static func categories(_ access: ReadAccess...) -> Scope {
        return Scope(name: "categories", access: access.map(\.rawValue))
    }

    public static func contacts(_ access: ReadAccess...) -> Scope {
        return Scope(name: "contacts", access: access.map(\.rawValue))
    }

    /// Access to the information describing the user's different bank credentials connected to Tink.
    public static func credentials(_ access: CredentialsAccess...) -> Scope {
        return Scope(name: "credentials", access: access.map(\.rawValue))
    }

    public static func dataExports(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "data-exports", access: access.map(\.rawValue))
    }

    public static func documents(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "documents", access: access.map(\.rawValue))
    }

    public static func follow(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "follow", access: access.map(\.rawValue))
    }

    /// Access to the user's personal information that can be used for identification purposes.
    public static func identity(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "identity", access: access.map(\.rawValue))
    }

    public static func insights(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "insights", access: access.map(\.rawValue))
    }

    /// Access to the user's portfolios and underlying financial instruments.
    public static func investments(_ access: ReadAccess...) -> Scope {
        return Scope(name: "investments", access: access.map(\.rawValue))
    }

    public static func properties(_ access: ReadWriteAccess...) -> Scope {
        return Scope(name: "properties", access: access.map(\.rawValue))
    }

    public static func providers(_ access: ReadAccess...) -> Scope {
        return Scope(name: "providers", access: access.map(\.rawValue))
    }

    /// Access to all the user's statistics, which can include filters on statistic.type.
    public static func statistics(_ access: ReadAccess...) -> Scope {
        return Scope(name: "statistics", access: access.map(\.rawValue))
    }

    public static func suggestions(_ access: ReadAccess...) -> Scope {
        return Scope(name: "suggestions", access: access.map(\.rawValue))
    }

    /// Access to all the user's transactional data.
    public static func transactions(_ access: TransactionAccess...) -> Scope {
        return Scope(name: "transactions", access: access.map(\.rawValue))
    }

    public static func transfer(_ access: TransferAccess...) -> Scope {
        return Scope(name: "transfer", access: access.map(\.rawValue))
    }

    /// Access to user profile data such as e-mail, date of birth, etc.
    public static func user(_ access: UserAccess...) -> Scope {
        return Scope(name: "user", access: access.map(\.rawValue))
    }
}
