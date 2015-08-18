//
//  AppDelegate.swift
//  Meniny
//
//  Created by Martin Pristas on 14.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa
import ServiceManagement
import EventKit

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let popover = NSPopover()
    let transientMonitor = NSEvent()
    
    var timer24hours = NSTimer()
    var shortTimer = NSTimer()
    
    lazy var store : EKEventStore = EKEventStore()
    
    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // calendar
        self.store.requestAccessToEntityType(EKEntityTypeEvent) {
            (success: Bool, error: NSError!) in
            //println("Got permission = \(success); error = \(error)")
        }
        
        
        var button = statusItem.button
        button!.action = Selector("togglePopover:")
        
        popover.contentViewController = ViewController(nibName: "ViewController", bundle: nil)
        popover.behavior = NSPopoverBehavior.Transient
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("NamesInMenu"))
        {
            button!.title = "🎁 " + NamesStack().getNameForToday()
            // Set timer from now to midnight for call change
            shortTimer = NSTimer.scheduledTimerWithTimeInterval(getDifferentTime(), target: self, selector: "change", userInfo: nil, repeats: false)
        }
        else
        {
            button!.title = "🎁"
        }
        
       
        // receive wake notification / system clock notification
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "receiveWakeOrChange", name: NSWorkspaceDidWakeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SystemClockChanged:", name: NSSystemClockDidChangeNotification, object: nil)
    }
    
    public func change()
    {
        statusItem.button?.title = "🎁 " +  NamesStack().getNameForToday()
        var oneDayInterval = 24 * 60 * 60
        timer24hours = NSTimer.scheduledTimerWithTimeInterval(Double(oneDayInterval), target: self, selector: "change", userInfo: nil, repeats: false)
        println("called change")
        
    }
    
    func receiveWakeOrChange()
    {
        shortTimer.invalidate()
        timer24hours.invalidate()
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("NamesInMenu"))
        {
            statusItem.button?.title = "🎁 " +  NamesStack().getNameForToday()
            shortTimer = NSTimer.scheduledTimerWithTimeInterval(getDifferentTime(), target: self, selector: "change", userInfo: nil, repeats: false)
        }
        else
        {
             statusItem.button!.title = "🎁"
        }
        
    }
    
    func SystemClockChanged(notification : NSNotificationCenter)
    {
        shortTimer.invalidate()
        timer24hours.invalidate()
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("NamesInMenu"))
        {
            statusItem.button?.title = "🎁 " +  NamesStack().getNameForToday()
            shortTimer = NSTimer.scheduledTimerWithTimeInterval(getDifferentTime(), target: self, selector: "change", userInfo: nil, repeats: false)
        }
        else
        {
            statusItem.button!.title = "🎁"
        }
    }


    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
            popover.behavior = NSPopoverBehavior.Transient
            
            
            
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
    
    func getDifferentTime() -> Double
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        
        
        //println(hour, minutes, seconds)
        
        var different = ((23 - hour) * 60 * 60) + ((59 - minutes) * 60) + (60 - seconds)
        return Double(different)
    }
    
    
    
}

