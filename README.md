# SJTwitterTagInputTextView

[![CI Status](http://img.shields.io/travis/Sumit Jagdev/SJTwitterTagInputTextView.svg?style=flat)](https://travis-ci.org/Sumit Jagdev/SJTwitterTagInputTextView)
[![Version](https://img.shields.io/cocoapods/v/SJTwitterTagInputTextView.svg?style=flat)](http://cocoapods.org/pods/SJTwitterTagInputTextView)
[![License](https://img.shields.io/cocoapods/l/SJTwitterTagInputTextView.svg?style=flat)](http://cocoapods.org/pods/SJTwitterTagInputTextView)
[![Platform](https://img.shields.io/cocoapods/p/SJTwitterTagInputTextView.svg?style=flat)](http://cocoapods.org/pods/SJTwitterTagInputTextView)

## Overview

SJTwitterTagInputTextView is a subclass of UIView, written in Swift, that enables the UIView to use as the "#" and "@" tag input view with suggestion list.

![](sample.gif?raw=true "SJTwitterTagInputTextView screenshot")

## Requirements
* ARC
* iOS8


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SJTwitterTagInputTextView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SJTwitterTagInputTextView"
```

## Usage

```Swift
import SJTwitterTagInputTextView

@IBOutlet var tagInputView : SJTwitterTagInputTextView!
tagInputView.delegate = self

//TODO : Please add height constraint and set id of constraint = "SJTextViewHeight"
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

```

## Author

Sumit Jagdev, sumitjagdev3@gmail.com

## License

SJTwitterTagInputTextView is available under the MIT license. See the LICENSE file for more info.
