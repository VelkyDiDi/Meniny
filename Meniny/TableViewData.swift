//
//  TableViewData.swift
//  Meniny
//
//  Created by Martin Pristas on 16.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa

class TableViewData: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    var TableViewObjects : NSArray = Array(NamesData().names.keys.array).sorted(<)
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return TableViewObjects.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        var cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
        
        cellView.textField!.stringValue = TableViewObjects.objectAtIndex(row) as! String
        
        return cellView
    }
    
}
