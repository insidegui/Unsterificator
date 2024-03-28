import Cocoa

protocol StatusItemMenuActions {
    func toggleLaunchAtLogin(_ sender: NSMenuItem)
    func configureKeyboardShortcut(_ sender: NSMenuItem)
    func terminate(_ sender: NSMenuItem)
}

final class StatusItemMenu: NSMenu {

    private var actions: StatusItemMenuActions

    init(actions: StatusItemMenuActions) {
        self.actions = actions
        
        super.init(title: "Unsterificator")

        addItem(withTitle: "Launch At Login", target: self, action: #selector(toggleLaunchAtLogin))
        addItem(withTitle: "Keyboard Shortcut…", target: self, action: #selector(configureKeyboardShortcut))
        
        addSeparator()
        
        addItem(withTitle: "Quit", target: self, action: #selector(StatusItemMenu.terminate))
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    @objc private func toggleLaunchAtLogin(_ sender: Any?) {
        guard let sender = sender as? NSMenuItem else {
            assertionFailure("Expected menu item action sender to me NSMenuItem")
            return
        }
        actions.toggleLaunchAtLogin(sender)
    }
    
    @objc private func configureKeyboardShortcut(_ sender: Any?) {
        guard let sender = sender as? NSMenuItem else {
            assertionFailure("Expected menu item action sender to me NSMenuItem")
            return
        }
        actions.configureKeyboardShortcut(sender)
    }

    @objc private func terminate(_ sender: Any?) {
        guard let sender = sender as? NSMenuItem else {
            assertionFailure("Expected menu item action sender to me NSMenuItem")
            return
        }
        actions.terminate(sender)
    }

}
