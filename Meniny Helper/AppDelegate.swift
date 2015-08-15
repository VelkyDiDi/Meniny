//
//  AppDelegate.swift
//  Meniny Helper
//
//  Created by Martin Pristas on 15.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        var pathComponents : NSArray = NSBundle.mainBundle().bundlePath.pathComponents
        
        pathComponents = (pathComponents.subarrayWithRange(NSMakeRange(0, (pathComponents.count - 4))))
        
        var path : String = String.pathWithComponents(pathComponents as! [String])
        NSWorkspace.sharedWorkspace().launchApplication(path)
        NSApplication.sharedApplication().terminate(self)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

