//
//  AppDelegateProtocol.swift
//  Rates
//
//  Created by Vasiliy Chistyakov on 08.05.2023.
//

import UIKit

struct AppRestorationDescr {
    let app: UIApplication
    let userActivity: NSUserActivity
    let handler: ([UIUserActivityRestoring]?) -> Void
}

protocol AppDelegateProtocol {
    func initModule(application: UIApplication, options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    var deinitModule: ((UIApplication) -> Void)? { get }
    var backgroundMethod: ((UIApplication) -> Void)? { get }
    var foregroundMethod: ((UIApplication) -> Void)? { get }
    var didBecomeActive: ((UIApplication) -> Void)? { get }
    var didRegisterForPushes: ((UIApplication, Data) -> Void)? { get }
    var continueUserActivity: ((AppRestorationDescr) -> Bool)? { get }
    var remoteNotification: (([AnyHashable: Any]) -> Void)? { get }
    var neededAfterInit: Bool { get }
    var canOpenURL: ((UIApplication, URL, [UIApplication.OpenURLOptionsKey: Any]) -> Bool)? { get }
    func description() -> String
}

// do not return methods by default
extension AppDelegateProtocol {
    /// by default the module is usually only used for initialization
    /// for a system at start
    var neededAfterInit: Bool {
        return false
    }

    var backgroundMethod: ((UIApplication) -> Void)? {
        return nil
    }

    var foregroundMethod: ((UIApplication) -> Void)? {
        return nil
    }

    var didBecomeActive: ((UIApplication) -> Void)? {
        return nil
    }

    var continueUserActivity: ((AppRestorationDescr) -> Bool)? {
        return nil
    }

    var remoteNotification: (([AnyHashable: Any]) -> Void)? {
        return nil
    }

    var didRegisterForPushes: ((UIApplication, Data) -> Void)? {
        return nil
    }

    var canOpenURL: ((UIApplication, URL, [UIApplication.OpenURLOptionsKey: Any]) -> Bool)? {
        return nil
    }

    var deinitModule: ((UIApplication) -> Void)? {
        return nil
    }
}

