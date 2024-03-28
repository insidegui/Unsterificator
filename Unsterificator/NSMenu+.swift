//
//  NSMenu.swift
//  ExtendedKit
//
//  Created by Dave DeLong on 3/8/23.
// https://github.com/davedelong/extendedswift
//

import Cocoa

extension NSMenu {

    @discardableResult
    func addItem(withTitle title: String, target: AnyObject, action: Selector, representedObject: Any? = nil) -> NSMenuItem {
        let i = self.addItem(withTitle: title, action: action, keyEquivalent: "")
        i.target = target
        i.representedObject = representedObject
        return i
    }

    @discardableResult
    func addSeparator() -> NSMenuItem {
        let separator = NSMenuItem.separator()
        self.addItem(separator)
        return separator
    }

}

