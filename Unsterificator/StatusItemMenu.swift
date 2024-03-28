import Cocoa

protocol StatusItemMenuActions {
    func presentSettings(_ sender: NSMenuItem)
    func terminate(_ sender: NSMenuItem)
}

final class StatusItemMenu: NSMenu {

    private var actions: StatusItemMenuActions

    init(actions: StatusItemMenuActions) {
        self.actions = actions
        
        super.init(title: "Unsterificator")

        addItem(withTitle: "Settings…", target: self, action: #selector(configureKeyboardShortcut))
        
        addSeparator()
        
        addItem(withTitle: "Quit", target: self, action: #selector(StatusItemMenu.terminate))
    }

    required init(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func configureKeyboardShortcut(_ sender: Any?) {
        guard let sender = sender as? NSMenuItem else {
            assertionFailure("Expected menu item action sender to me NSMenuItem")
            return
        }
        actions.presentSettings(sender)
    }

    @objc private func terminate(_ sender: Any?) {
        guard let sender = sender as? NSMenuItem else {
            assertionFailure("Expected menu item action sender to me NSMenuItem")
            return
        }
        actions.terminate(sender)
    }

}
