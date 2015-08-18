//
//  NamesStack.swift
//  Meniny
//
//  Created by Martin Pristas on 15.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa

public class NamesStack {

    let names = NamesData().names
    let holidays = HolidaysData().holidays
    
    
    public func getNameForToday() -> String
    {
        var namesForKeys : NSArray = (names as NSDictionary).allKeysForObject(getActualDate()) as NSArray
        var namesToday = ""
        
        switch (namesForKeys.count)
        {
        case 0:
            namesToday = "Dneska neoslavuje nikto."
            break;
        case 1:
            namesToday = namesForKeys.objectAtIndex(0) as! String
            break;
        case 2:
            namesToday = namesForKeys.objectAtIndex(0) as! String + ", " + (namesForKeys.objectAtIndex(1) as! String)
            break;
        case 3:
            namesToday = namesForKeys.objectAtIndex(0) as! String + ", " + (namesForKeys.objectAtIndex(1) as! String) + ", " + (namesForKeys.objectAtIndex(2) as! String)
            break;
        default:
            break;
        }
        
        return namesToday
    }
    
    public func getNameForTommorow() -> String
    {
        var namesForKeys : NSArray = (names as NSDictionary).allKeysForObject(getTommorowDate()) as NSArray
        var namesTommorow = ""
        
        switch (namesForKeys.count)
        {
        case 0:
            namesTommorow = "Zajtra neoslavuje nikto."
            break;
        case 1:
            namesTommorow = namesForKeys.objectAtIndex(0) as! String
            break;
        case 2:
            namesTommorow = namesForKeys.objectAtIndex(0) as! String + ", " + (namesForKeys.objectAtIndex(1) as! String)
            break;
        case 3:
            namesTommorow = namesForKeys.objectAtIndex(0) as! String + ", " + (namesForKeys.objectAtIndex(1) as! String) + ", " + (namesForKeys.objectAtIndex(2) as! String)
            break;

        default:
            break;
        }
        
        return namesTommorow
    }
    
    func getActualDate() -> String
    {
        let date_today = NSDate();
        
        var format_day_label = NSDateFormatter()
        format_day_label.dateFormat = "dd.MM."
        
        var date = format_day_label.stringFromDate(date_today)
        
        return date
    }
    
    func getTommorowDate()->String
    {
        let date_tommorow = NSDate(timeIntervalSinceNow: 60*60*24)
        
        var format_day_label = NSDateFormatter()
        format_day_label.dateFormat = "dd.MM."
        
        var date = format_day_label.stringFromDate(date_tommorow)
        
        return date

    }
    
    func getNearestHoliday()->(String, Bool)
    {
        let date_today = NSDate();
        var format_day_label = NSDateFormatter()
        format_day_label.dateFormat = "dd.MM."
        var date = format_day_label.stringFromDate(date_today)
        
        var holidays = HolidaysData().holidays
        if (holidays[date] == nil)
        {
            var i = 1
            while (true)
            {
                let nextDate = NSDate(timeIntervalSinceNow: Double(60*60*24 * i))
                var formatNextDate = NSDateFormatter()
                formatNextDate.dateFormat = "dd.MM."
                var myDateFormatted = formatNextDate.stringFromDate(nextDate)
                
                if (holidays[myDateFormatted] != nil)
                {
                    return (myDateFormatted + " " + holidays[myDateFormatted]!, false)
                }
                
                i++
                
            }
        }
        else
        {
            return ("🎉 " + holidays[date]!, true)
        }
        
        
    }
    
}
