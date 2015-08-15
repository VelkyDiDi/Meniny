//
//  ViewController.swift
//  Meniny
//
//  Created by Martin Pristas on 15.8.2015.
//  Copyright (c) 2015 Martin Pristas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func sdf(sender: AnyObject) {
        println("asdaaa")
    }
    var AppDel = AppDelegate()
    var NamesStackOperations = NamesStack()
    var NamesDataCore = NamesData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var names = NamesDataCore.names
        println(names)
        
        let objectForKey = (names as NSDictionary).allKeysForObject("3.8.")
        println(objectForKey)
    }
    
    @IBAction func callChange(sender: AnyObject)
    {
        println("called")
        AppDel.change()
    }
    
    func callAd()
    {
        println("asd")
    }
    
}
