//
//  ViewController.swift
//  Meniny
//
//  Created by Martin Pristas on 15.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa
import ServiceManagement

class ViewController: NSViewController{

    @IBOutlet weak var nameForToday: NSTextField!
    
    @IBOutlet weak var nameForTommorow: NSTextField!
    
    @IBOutlet weak var holiday: NSTextField!
    @IBOutlet weak var checkFieldLaunchApp: NSButton!
    @IBOutlet weak var checkFieldNamesInMenu: NSButton!
    
    @IBOutlet weak var creatorInfo: NSButton!
    
    @IBOutlet weak var tableOfNames: NSTableView!
    @IBOutlet weak var columnNames: NSTextFieldCell!
    @IBOutlet weak var columnDates: NSTextFieldCell!
    
    
    
    var names = NamesData().names
    var holidays = HolidaysData().holidays
    var TableViewObjects : NSArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TableViewObjects = Array(names.keys).sorted(<)
        //myTableView.reloadData()
        tableOfNames.backgroundColor = NSColor.clearColor()
        
       
        // create some people
        
    }
    
    
    override func viewWillAppear() {

        nameForToday.stringValue = NamesStack().getNameForToday()
        nameForTommorow.stringValue = NamesStack().getNameForTommorow()
        holiday.stringValue = NamesStack().getNearestHoliday()
        
        // First run - set LoginEnabled and Names in MenuBar as enabled
        if (!NSUserDefaults.standardUserDefaults().boolForKey("FirstRun"))
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LoginEnabled")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NamesInMenu")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstRun")
            println("this is first run")
        }
        
        checkFieldLaunchApp.state = Int(NSUserDefaults.standardUserDefaults().boolForKey("LoginEnabled"))
        checkFieldNamesInMenu.state = Int(NSUserDefaults.standardUserDefaults().boolForKey("NamesInMenu"))
        
        
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
            println("true")
        
        if appearance == "Light"
        {
            columnNames.textColor = NSColor.blackColor()
            columnDates.textColor = NSColor.blackColor()
        }
        else
        {
            columnNames.textColor = NSColor.whiteColor()
            columnDates.textColor = NSColor.whiteColor()
        }
        
        
    }
    
    @IBAction func setLaunchApp(sender: AnyObject)
    {
        var button = sender as! NSButton
        var state = button.state
        NSUserDefaults.standardUserDefaults().setBool(Bool(state), forKey: "LoginEnabled")
        
        // set to launch application at start
        let launchDaemon: CFStringRef = "sk.freetech.OSX.Meniny-Helper"
        
        if (SMLoginItemSetEnabled(launchDaemon, Boolean(state)) == 0)
        {
            println("Set launch app wasn't successfull")
        }
        
    }
    
    @IBAction func setNamesInMenu(sender: AnyObject)
    {
        var button = sender as! NSButton
        var state = button.state
        NSUserDefaults.standardUserDefaults().setBool(Bool(state), forKey: "NamesInMenu")
        
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "sleep 0.0; open \"\(NSBundle.mainBundle().bundlePath)\""]
        task.launch()
        NSApplication.sharedApplication().terminate(nil)
    }
    
    @IBAction func openCreatorWebPage(sender: AnyObject)
    {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.freetech.sk/")!)
    }
 
}
