import Foundation
import AudioToolbox

final class AudioFeedback {

    private let filename: String
    private var systemSoundID: SystemSoundID = .zero

    init(filename: String) {
        self.filename = filename
    }

    func play() {
        guard Settings.current.soundFeedbackEnabled else { return }
        
        guard let soundID = getSystemSoundID() else { return }
        
        AudioServicesPlaySystemSound(soundID)
    }

}

extension AudioFeedback {
    static let stereo = AudioFeedback(filename: "Feedback-Stereo.caf")
    static let mono = AudioFeedback(filename: "Feedback-Mono.caf")
}

// MARK: - Sound Registration

private extension AudioFeedback {
    func getSystemSoundID() -> SystemSoundID? {
        if systemSoundID != .zero { return systemSoundID }
        guard let registeredSoundID = registerSystemSoundID() else { return nil }
        return registeredSoundID
    }

    func registerSystemSoundID() -> SystemSoundID? {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
            assertionFailure("Missing feedback sound file")
            return nil
        }

        var soundID: SystemSoundID = .zero
        let result = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        guard result == kIOReturnSuccess else {
            assertionFailure("Failed to register system sound. Error code \(result)")
            return nil
        }
        return soundID
    }

}
