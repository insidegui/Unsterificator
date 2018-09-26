//
//  AppDelegate.swift
//  Unsterificator
//
//  Created by Guilherme Rambo on 17/05/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var statusController: StatusItemController = StatusItemController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusController.install()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

