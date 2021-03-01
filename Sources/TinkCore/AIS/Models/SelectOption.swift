import Foundation
/// A list of options where the user should select one.
public struct SelectOption {
    /// A URL the client can optionally use to show an icon to represent the option.
    let iconUrl: String?
    /// The human-readable description of this option to display to the user.
    let text: String?
    /// The machine-readable value to send if the user picks this option.
    let value: String?

    init(iconUrl: String, text: String, value: String) {
        self.iconUrl = iconUrl
        self.text = text
        self.value = value
    }
}
