import Foundation
/// A list of options where the user should select one.
public struct SelectOption: Equatable {
    /// A URL the client can optionally use to show an icon to represent the option.
    public let iconURL: URL?
    /// The human-readable description of this option to display to the user.
    public let text: String?
    /// The machine-readable value to send if the user picks this option.
    public let value: String?

    init(iconURL: URL, text: String, value: String) {
        self.iconURL = iconURL
        self.text = text
        self.value = value
    }

    internal init(restSelectOption: RESTSelectOption) {
        self.iconURL = restSelectOption.iconUrl
        self.text = restSelectOption.text
        self.value = restSelectOption.value
    }
}
