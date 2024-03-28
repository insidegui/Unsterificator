//
//  StatusItemController.swift
//  Unsterificator
//
//  Created by Guilherme Rambo on 17/05/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

import Cocoa

final class StatusItemController: NSObject {
    
    private lazy var unsterificator: Unsterificator = Unsterificator()
    
    private var statusItem: NSStatusItem!
    
    private var imageForCurrentState: NSImage {
        if unsterificator.isUnsterified {
            return #imageLiteral(resourceName: "mono")
        } else {
            return #imageLiteral(resourceName: "stereo")
        }
    }
    
    private var descriptionForCurrentState: String {
        if unsterificator.isUnsterified {
            return "playing stereo as mono"
        } else {
            return "stereo"
        }
    }

    private lazy var menu: NSMenu = {
        let m = NSMenu(title: "Unsterificator")

        let item = m.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "")
        item.target = NSApp

        return m
    }()
    
    func install() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        statusItem.button?.target = self
        statusItem.button?.action = #selector(menuIconClicked)

        updateStatus()
        
        unsterificator.settingDidChangeExternally = { [weak self] in
            self?.updateStatus()
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
    
}

fileprivate extension NSEvent {

    var shouldShowMenu: Bool {
        return modifierFlags.contains(.control)
               || modifierFlags.contains(.option)
               || type == .rightMouseDown
    }

}
