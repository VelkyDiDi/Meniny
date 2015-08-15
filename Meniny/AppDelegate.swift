//
//  AppDelegate.swift
//  Meniny
//
//  Created by Martin Pristas on 14.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    var button : NSStatusBarButton!
    
    let popover = NSPopover()
    
    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        var button = statusItem.button
        button!.title = "Dneska oslavujeee"
        button!.action = Selector("togglePopover:")
        
        popover.contentViewController = ViewController(nibName: "ViewController", bundle: nil)
        
        let launchDaemon: CFStringRef = "sk.freetech.OSX.Meniny-Helper"
        
        if (SMLoginItemSetEnabled(launchDaemon, Boolean(1)) == 0)
        {
            println("asd/")
        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        
        
        println(hour, minutes, seconds)
        
        var different = ((23 - hour) * 60 * 60) + ((59 - minutes) * 60) + (60 - seconds)
        NSTimer.scheduledTimerWithTimeInterval(Double(10), target: self, selector: "change", userInfo: nil, repeats: false)
        
        println(different)
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    public func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    public func change()
    {
        print("now")
        //statusItem.button?.title = (statusItem.button!.title as String) + " 1"
        println("this is 24 h")
        NSTimer.scheduledTimerWithTimeInterval(50, target: self, selector: "change", userInfo: nil, repeats: false)
    }
    
    
    
}

