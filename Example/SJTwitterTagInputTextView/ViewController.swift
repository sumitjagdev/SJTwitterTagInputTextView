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
        
        allObjectList = NSLocale.isoCountryCodes
        var arr : [String] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            arr.append(name)
        }

        
        allObjectList = arr
        
//        let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15) ]
//        tagInputView.textview
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
        let newArray = array?.filtered(using: predicate)
        
        tagInputView.allObjectList = newArray as! [String]
        
    }
    
    func didSearchWithHashTag(tagString: String) {
        //        print("Current Search Word # : ", tagString)
        
        let predicate = NSPredicate(format: "SELF contains[cd] %@", tagString)
        let array = allObjectList as NSArray!
        let newArray = array?.filtered(using: predicate)
        
        tagInputView.allObjectList = newArray as! [String]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("All @ Tags : ", tagInputView.getAllAtTags())
        print("All # Tags : ", tagInputView.getAllHashTags())
    }
}
