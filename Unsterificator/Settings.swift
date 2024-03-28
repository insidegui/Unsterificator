import SwiftUI

final class Settings: ObservableObject {
    static let current = Settings()

    @AppStorage("soundFeedbackEnabled")
    var soundFeedbackEnabled = true

    private init() { }
}
