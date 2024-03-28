//
//  StatusItemController.swift
//  Unsterificator
//
//  Created by Guilherme Rambo on 17/05/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

import Cocoa
import KeyboardShortcuts

final class StatusItemController: NSObject {

    private lazy var unsterificator: Unsterificator = Unsterificator()
    
    private var statusItem: NSStatusItem!
    
    private var imageForCurrentState: NSImage {
        if unsterificator.isUnsterified {
            return .statusItemMono
        } else {
            return .statusItemStereo
        }
    }
    
    private var descriptionForCurrentState: String {
        if unsterificator.isUnsterified {
            return "playing stereo as mono"
        } else {
            return "stereo"
        }
    }

    private lazy var menu: StatusItemMenu = {
        StatusItemMenu(actions: self)
    }()

    func install() {
        menu.delegate = self
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else {
            assertionFailure("NSStatusItem has no button!")
            return
        }

        button.target = self
        button.action = #selector(menuIconClicked)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        updateStatus()
        
        unsterificator.settingDidChangeExternally = { [weak self] in
            self?.updateStatus()
        }

        KeyboardShortcuts.onKeyUp(for: .toggleMonoAudio) { [weak self] in
            guard let self else { return }
            shortcutToggle()
        }
    }
    
    private func updateStatus() {
        statusItem.button?.image = imageForCurrentState
        statusItem.button?.toolTip = "Unsterificator (\(descriptionForCurrentState))"
    }
    
    @objc private func menuIconClicked(_ sender: Any?) {
        guard let event = NSApp.currentEvent else { return }

        if event.shouldShowMenu {
            showMenu(sender)
        } else {
            toggle(sender)
        }
    }

    private func showMenu(_ sender: Any?) {
        guard let referenceView = sender as? NSView else { return }

        let point = NSPoint(x: 0, y: referenceView.bounds.maxY + 4)
        menu.popUp(positioning: nil, at: point, in: referenceView)
    }

    private func toggle(_ sender: Any?) {
        unsterificator.isUnsterified = !unsterificator.isUnsterified

        updateStatus()
    }

    private func shortcutToggle() {
        flashStatusItem()
        toggle(nil)
    }

    private func flashStatusItem() {
        statusItem.button?.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.statusItem.button?.isHighlighted = false
        }
    }

    // MARK: - Settings Window

    private var settingsController: NSWindowController?

    func showSettingsWindow() {
        if let settingsController {
            settingsController.showWindow(nil)
            return
        }

        let wc = SettingsWindowController()
        wc.onClose { [weak self] _ in
            self?.settingsController = nil
        }
        self.settingsController = wc
        wc.showWindow(nil)
    }

}

fileprivate extension NSEvent {

    var shouldShowMenu: Bool {
        return modifierFlags.contains(.control)
               || modifierFlags.contains(.option)
               || type == .rightMouseUp
    }

}

extension StatusItemController: StatusItemMenuActions, NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        print("menuDidClose")
    }

    func presentSettings(_ sender: NSMenuItem) {
        print("presentSettings called in mode \(String(describing: RunLoop.current.currentMode))")

        sender.menu!.cancelTrackingWithoutAnimation()

        RunLoop.current.perform(inModes: [.default]) {
            self.showSettingsWindow()
        }
    }
    
    func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
}
