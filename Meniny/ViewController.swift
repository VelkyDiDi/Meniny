//
//  ViewController.swift
//  Meniny
//
//  Created by Martin Pristas on 15.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa
import ServiceManagement
import EventKit
import AppKit

var clickedName : String!

public class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSPopoverDelegate{

    @IBOutlet weak var nameForToday: NSTextField!
    
    @IBOutlet weak var nameForTommorow: NSTextField!
    
    @IBOutlet weak var holiday: NSTextField!
    @IBOutlet weak var holidayTitle: NSTextField!
    @IBOutlet weak var checkFieldLaunchApp: NSButton!
    @IBOutlet weak var checkFieldNamesInMenu: NSButton!
    
    @IBOutlet weak var creatorInfo: NSButton!
    
    @IBOutlet weak var tableOfNames: NSTableView!
    @IBOutlet weak var columnNames: NSTextFieldCell!
    @IBOutlet weak var columnDates: NSTextFieldCell!
    
    let popover = NSPopover()
    
    
    
    // Calendar
    
    //let eventStore = EKEventStore()
    
    
    var names = NamesData().names
    var holidays = HolidaysData().holidays
    var TableViewObjects : NSArray = NSArray()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        TableViewObjects = Array(names.keys).sorted(<)
        
        tableOfNames.backgroundColor = NSColor.clearColor()
        
       
        tableOfNames.becomeFirstResponder()
        
    }
    
    
    override public func viewWillAppear() {

        nameForToday.stringValue = NamesStack().getNameForToday()
        nameForTommorow.stringValue = NamesStack().getNameForTommorow()
        
        // Holiday event
        var (holidayLabel, todayHoliday) = NamesStack().getNearestHoliday()
        holiday.stringValue = holidayLabel
        if (todayHoliday)
        {
            holidayTitle.stringValue = "Sviatok"
        }
        
        checkFieldLaunchApp.state = Int(NSUserDefaults.standardUserDefaults().boolForKey("LoginEnabled"))
        checkFieldNamesInMenu.state = Int(NSUserDefaults.standardUserDefaults().boolForKey("NamesInMenu"))
        
        
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
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
        
        
        popover.becomeFirstResponder()
        popover.delegate = self
        tableOfNames.deselectRow(tableOfNames.selectedRow)
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
    
    public func tableViewSelectionDidChange(notification: NSNotification)
    {
        if (self.tableOfNames.numberOfSelectedRows > 0)
        {
            let selectedItem = TableViewObjects.objectAtIndex(self.tableOfNames.selectedRow) as! String

            
            self.tableOfNames.deselectRow(self.tableOfNames.selectedRow)
            
            
            
        }
        
    }
    
    
    @IBAction func tableAction(sender: AnyObject) {
    
        var table = sender as! NSTableView
        
        var clicked_Column = table.clickedColumn
        var clicked_row = table.clickedRow
        
        //var view : NSTableViewDataSource = table.dataSource()!
        
        var row = table.selectedRow
        var columnName : NSTableColumn = table.tableColumnWithIdentifier("name")!
        var cellName : NSCell = columnName.dataCellForRow(row) as! NSCell
        
        var columnDate : NSTableColumn = table.tableColumnWithIdentifier("date")!
        var cellDate : NSCell = columnDate.dataCellForRow(row) as! NSCell
        //println((cellName.stringValue))
        
        if (clicked_Column == 2)
        {
            clickedName = cellName.stringValue
            
            var position = table.frameOfCellAtColumn(clicked_Column, row: clicked_row)
            
            popover.contentViewController = nameInfoVC(nibName: "nameInfoVC", bundle: nil)
            popover.showRelativeToRect(position, ofView: tableOfNames, preferredEdge: NSMinYEdge)
            popover.behavior = NSPopoverBehavior.Transient
            
            
        }
        
    }
   
}
