import SwiftUI
import LaunchAtLogin

final class SettingsWindowController: NSWindowController, NSWindowDelegate {
    convenience init() {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 200), styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        self.init(window: window)
        window.delegate = self
        window.titlebarAppearsTransparent = true
        window.title = "Unsterificator Settings"
        let viewController = NSHostingController(rootView: SettingsScreen())
        self.contentViewController = viewController
        viewController.preferredContentSize = viewController.view.fittingSize
    }

    private var onCloseCallback: ((SettingsWindowController) -> Void)?

    func onClose(perform block: @escaping (SettingsWindowController) -> Void) {
        self.onCloseCallback = block
    }

    override func showWindow(_ sender: Any?) {
        NSApp.setActivationPolicy(.regular)

        super.showWindow(sender)

        window?.center()

        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        onCloseCallback?(self)
    }
}

struct SettingsScreen: View {
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var body: some View {
        Form {
            Toggle("Launch at login", isOn: $launchAtLogin.isEnabled)
        }
        .formStyle(.grouped)
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
    }
}
