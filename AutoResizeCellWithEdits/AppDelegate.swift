//
//  AppDelegate.swift
//  AutoResizeCellWithEdits
//
//  Created by mw on 2016-07-26.
//  Copyright © 2016 mw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let itemStore = ItemStore()
        let controller = window!.rootViewController as! MyTableViewController
        controller.store = itemStore
        
        itemStore.appendItem("1 First of the first.")
        itemStore.appendItem("2 Then comes a slightly longer text, which may be wordy enough for a word wrap to happen and to occur. If we're lucky.")
        itemStore.appendItem("3 And now for something entirely different. Or maybe not.")
        itemStore.appendItem("4 Second of the second.")
        itemStore.appendItem("5 Then comes a slightly longer text, which may be wordy enough for a word wrap to happen and to occur. If we're lucky.")
        itemStore.appendItem("6 And now for something entirely different. Or maybe not.")
        itemStore.appendItem("7 Third of the third.")
        itemStore.appendItem("8 Then comes a slightly longer text, which may be wordy enough for a word wrap to happen and to occur. If we're lucky.")
        itemStore.appendItem("9 And now for something entirely different. Or maybe not.")
        itemStore.appendItem("10 Fourth of the fourth.")
        itemStore.appendItem("11 Then comes a slightly longer text, which may be wordy enough for a word wrap to happen and to occur. If we're lucky.")
        itemStore.appendItem("12 And now for something entirely different. Or maybe not.")
        
        return true
    }
    
    

}

