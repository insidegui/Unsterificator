//
//  Unsterificator.swift
//  Unsterificator
//
//  Created by Guilherme Rambo on 17/05/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let UASoundSettingsDidChangeNotification = Notification.Name("UniversalAccessDomainSoundSettingsDidChangeNotification")
}

final class Unsterificator {
    
    init() {
        DistributedNotificationCenter.default().addObserver(forName: .UASoundSettingsDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.settingDidChangeExternally?()
        }
    }
    
    var settingDidChangeExternally: (() -> Void)?
    
    var isSupported: Bool {
        return UAPlayStereoAsMonoIsSupported()
    }
    
    var isUnsterified: Bool {
        get {
            return UAPlayStereoAsMonoIsEnabled()
        }
        set {
            UAPlayStereoAsMonoSetEnabled(newValue)
        }
    }
    
}
