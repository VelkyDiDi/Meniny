//
//  nameInfoVC.swift
//  Meniny
//
//  Created by Martin Pristas on 17.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa
import EventKit

class nameInfoVC: NSViewController {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var calendarButton: NSButton!
    @IBOutlet weak var calendarImage: NSImageView!
    @IBOutlet weak var calendarTextLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        println("asd \(clickedName)")
        
        
        
        
    }
    
    override func viewWillAppear() {
        nameLabel.stringValue = clickedName
        var foundName = false;
        
        var nameDate = getDateFromName()
        let eventStore = EKEventStore()
        
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar] // Grab every calendar the user has
        
        let calendarsArray : [EKCalendar] = [sendNameDayCalendar()]
        
        var fetchRequest : NSPredicate = eventStore.predicateForEventsWithStartDate(nameDate, endDate: nameDate, calendars: calendarsArray)
        var eventList : NSArray! = eventStore.eventsMatchingPredicate(fetchRequest)
        for (var i = 0 ; i < eventList.count ; i++)
        {
           var eventTitle = eventStore.calendarItemWithIdentifier(eventList.objectAtIndex(i).calendarItemIdentifier).title
            
            if eventTitle == clickedName
            {
                foundName = true
            }
           
        }
        
        if foundName
        {
            calendarButton.hidden = true
            calendarImage.image = NSImage(named: "calendar-added")
            calendarTextLabel.stringValue = "pridané v kalendári"
            
        }
    }
    
    @IBAction func addToCalendar(sender: AnyObject)
    {
        
        var eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            (granted, error) in
            
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                let recur = EKRecurrenceRule(
                    recurrenceWithFrequency:EKRecurrenceFrequencyYearly, // every year
                    interval:1, // no, every *two* years
                    daysOfTheWeek:nil,
                    daysOfTheMonth:nil,
                    monthsOfTheYear:nil,
                    weeksOfTheYear:nil,
                    daysOfTheYear:nil,
                    setPositions: nil,
                    end:nil)
                let alarm = EKAlarm(relativeOffset: 7*60*60)
                
                event.title = clickedName
                event.startDate = self.getDateFromName()
                event.endDate = self.getDateFromName()
                event.allDay = true
                event.notes = ""
                event.addRecurrenceRule(recur)
                event.calendar = self.sendNameDayCalendar()
                event.addAlarm(alarm)
                eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: nil)
                
                println("Saved Event")
                
                self.viewWillAppear()
            }
        })
    }
    
    func sendNameDayCalendar() -> EKCalendar
    {
        let eventStore = EKEventStore()
        
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar] // Grab every calendar the user has
        var exists: Bool = false
        for calendar in calendars {
            if calendar.title == "Meniny" {
                exists = true
                return calendar
            }
        }
        
        var err : NSError?
        if !exists {
            let newCalendar = EKCalendar(forEntityType:EKEntityTypeEvent, eventStore:eventStore)
            newCalendar.title="Meniny"
            newCalendar.source = eventStore.defaultCalendarForNewEvents.source
            eventStore.saveCalendar(newCalendar, commit:true, error:&err)
            return newCalendar
        }

    }
    
    
    func getThisYear()->String
    {
    
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: date)
        let year = components.year

        return String(year)
    }
    
    func getDateFromName()-> NSDate
    {
        var names = NamesData().names
        var myDate = names[clickedName]! + getThisYear()
        
        let date_formatter = NSDateFormatter()
        date_formatter.timeZone = NSTimeZone(name: "GMT")
        date_formatter.dateFormat = "dd.MM.yyyy"
        let date : NSDate! = date_formatter.dateFromString(myDate)!
        
        return date
    }
    
}
