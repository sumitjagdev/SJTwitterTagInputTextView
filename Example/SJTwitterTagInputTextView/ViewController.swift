//
//  ViewController.swift
//  SJTwitterTagInputTextView
//
//  Created by Sumit Jagdev on 12/27/2016.
//  Copyright (c) 2016 Sumit Jagdev. All rights reserved.
//

import UIKit
import SJTwitterTagInputTextView

class ViewController: UIViewController , SJTwitterTagInputTextViewDelegate {
    
    @IBOutlet var tagInputView : SJTwitterTagInputTextView!
    
    var allObjectList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagInputView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        allObjectList = NSLocale.ISOCountryCodes()
        var arr : [String] = []
        for str in NSLocale.ISOCountryCodes() {
            arr .append(str.countryName())
        }
        allObjectList = arr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : SJTwitterTagInputTextViewDelegate
    func didSearchWithAtTag(tagString: String) {
        //        print("Current Search Word @ : ", tagString)
        
        let predicate = NSPredicate(format: "SELF contains[cd] %@", tagString)
        let array = allObjectList as NSArray!
        let newArray = array.filteredArrayUsingPredicate(predicate)
        
        tagInputView.allObjectList = newArray as! [String]
        
    }
    
    func didSearchWithHashTag(tagString: String) {
        //        print("Current Search Word # : ", tagString)
        
        let predicate = NSPredicate(format: "SELF contains[cd] %@", tagString)
        let array = allObjectList as NSArray!
        let newArray = array.filteredArrayUsingPredicate(predicate)
        
        tagInputView.allObjectList = newArray as! [String]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("All @ Tags : ", tagInputView.getAllAtTags())
        print("All # Tags : ", tagInputView.getAllHashTags())
    }
}
