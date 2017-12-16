//
//  SJTagTextView.swift
//  TagsDemo
//
//  Created by Mac on 12/20/16.
//  Copyright © 2016 Sumit Jagdev. All rights reserved.
//

import UIKit

typealias SJ_CompletionHandler = (_ isSuccess: Bool, _ error: NSError?, _ response: NSDictionary?)->Void


public protocol SJTwitterTagInputTextViewDelegate: class {
    func didSearchWithHashTag(tagString: String)
    func didSearchWithAtTag(tagString: String)
}


public class SJTwitterTagInputTextView: UIView, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBInspectable var textViewBackgroundColor : UIColor = UIColor.white {
        didSet {
            self.backgroundColor = textViewBackgroundColor
        }
    }
    var textView        : UITextView!
    var resultTableView : UITableView!
    
    var cellIdentifier : String = "cellId"
    var heightConstId : String = "SJTextViewHeight"
    
    var heightConstraintOfSelf : NSLayoutConstraint!
    
    var leadingConstraintOfTextView : NSLayoutConstraint!
    var trailingConstraintOfTextView : NSLayoutConstraint!
    var topConstraintOfTextView : NSLayoutConstraint!
    var heightConstraintOfTextView : NSLayoutConstraint!
    
    
    var leadingConstraintOfTableView : NSLayoutConstraint!
    var trailingConstraintOfTableView : NSLayoutConstraint!
    var bottomConstraintOfTableView : NSLayoutConstraint!
    var topConstraintOfTableView : NSLayoutConstraint!
    var heightConstraintOfTableView : NSLayoutConstraint!
    
    var rangeOfTagString : NSRange!
    
    var isAtTag : Bool = false
    
    public var allObjectList : [String] = [] {
        didSet {
            if resultTableView != nil {
                filteredObjectList = allObjectList
                resultTableView .reloadData()
            }
        }
    }
    
    var filteredObjectList : [String] = []
    
    public weak var delegate: SJTwitterTagInputTextViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.lightGray
        textView = UITextView()
        textView.delegate = self
        textView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.addSubview(textView)
        
        //==========================================
        
        resultTableView = UITableView()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.addSubview(resultTableView)
        resultTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        

        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2.0
        
        
        resultTableView.layer.borderColor = UIColor.darkGray.cgColor
        resultTableView.layer.borderWidth = 2.0
        
        
        textView.backgroundColor = UIColor.white
        resultTableView.backgroundColor = UIColor.white
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        resultTableView.isUserInteractionEnabled = true
        resultTableView.allowsSelection = true
        let allConstraints = self.constraints
        for const in allConstraints {
            if const.identifier == heightConstId {
//                const.priority = UILayoutPriorityDefaultLow
                heightConstraintOfSelf = const
            }
        }
        
        if topConstraintOfTextView != nil {
            return
        }
        var frame : CGRect = self.frame
        frame.origin = CGPoint.zero
        textView.frame = frame
        
        topConstraintOfTextView = textView.addTopConstraint(toView: self, constant: 0.0)
        leadingConstraintOfTextView = textView.addLeadingConstraint(toView: self, constant: 0.0)
        trailingConstraintOfTextView = textView.addTrailingConstraint(toView: self, constant: 0.0)
        heightConstraintOfTextView = textView.addHeightConstraint(heightConstant: frame.size.height)
        
        //==========================================
        
        frame.origin.y = 100
        frame.size.height = 100
        resultTableView.frame = frame
        self.bringSubview(toFront: resultTableView)
        
        topConstraintOfTextView = resultTableView.addTopConstraint(toView: self, constant: heightConstraintOfTextView.constant)
        trailingConstraintOfTableView = resultTableView.addTrailingConstraint(toView: self, constant: 0.0)
        bottomConstraintOfTableView = resultTableView.addBottomConstraint(toView: self, constant: 0.0)
        leadingConstraintOfTableView = resultTableView.addLeadingConstraint(toView: self, constant: 0.0)
//        heightConstraintOfTableView = resultTableView.addHeightConstraint(heightConstant: 100)
        
        resultTableView.reloadData()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "@" {
            
        }
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
//        textView.validateForTags()
        var currentWord = textView.getCurrentWord()
        currentWord = currentWord.replacingOccurrences(of: "\n", with: " ")
        
//        print("Current Word : ", currentWord)
        currentWord = currentWord.replacingOccurrences(of: " ", with: "")
        
        if currentWord.hasPrefix("@")  || currentWord.hasPrefix("#") {
            if currentWord.hasPrefix("@") {
                isAtTag = true
            }else{
                isAtTag = false
            }
            self.callServiceFor(hashTagString: currentWord)
        }else{
            filteredObjectList = []
        }
    
        resultTableView.reloadData()
        
        textView.validateForTagsColor()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredObjectList.count > 0 {
            if heightConstraintOfSelf != nil && heightConstraintOfTextView != nil {
                var height = filteredObjectList.count * 25
                if height > 100 {
                    height = 100
                }
                heightConstraintOfSelf.constant = heightConstraintOfTextView.constant + CGFloat(height)
            }
            return filteredObjectList.count
        }
        if heightConstraintOfSelf != nil && heightConstraintOfTextView != nil {
            heightConstraintOfSelf.constant = heightConstraintOfTextView.constant
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.backgroundColor = UIColor.clear
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .default
        cell.textLabel?.text = "Cell \(indexPath.row)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        if filteredObjectList.count > indexPath.row{
            cell?.textLabel?.text = filteredObjectList[indexPath.row]
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected row index : ", indexPath.row)
        if filteredObjectList.count > indexPath.row {
            
            let replacementString = filteredObjectList[indexPath.row]

            var newReplacementString = NSString(format: "#%@ ", replacementString) as String
            if isAtTag == true {
                newReplacementString = NSString(format: "@%@ ", replacementString) as String
            }
            textView.changeCurrentWordWith(newWordString: newReplacementString as NSString)
            filteredObjectList = []
            tableView .reloadData()
        }
        textView.validateForTagsColor()
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func callServiceFor(hashTagString : String) {
        let newArray = hashTagString.components(separatedBy: "\n")
        let hashTag = newArray.last
        
        if (hashTag?.isEmpty)! {
//            searchResultTableView.isHidden = true
            filteredObjectList = []
            resultTableView.reloadData()
            return
        }
       
        var strTag : String! = ""
        if (hashTag?.hasPrefix("@"))! {
            strTag =  hashTag?.replacingOccurrences(of: "@", with: "")
            if delegate != nil {
                delegate?.didSearchWithAtTag(tagString: strTag)
            }
            
        }else if (hashTag?.hasPrefix("#"))! {
            strTag =  hashTag?.replacingOccurrences(of: "#", with: "")
            if delegate != nil {
                delegate?.didSearchWithHashTag(tagString: strTag)
            }
        }
        
        let fullText : NSString = textView.text as NSString
        rangeOfTagString  = fullText.range(of: strTag)
        rangeOfTagString = textView.getCurrentWordRange()
        

        
//        let predicate = NSPredicate(format: "SELF contains[cd] %@", strTag!)
//        filteredObjectList = allObjectList.filter { predicate.evaluate(with: $0) }
//        resultTableView.reloadData()
    }
    
    public func getAllAtTags() -> [String] {
        if textView == nil {
            return []
        }
        return textView.getAllAtTags()
    }
    
    public func getAllHashTags() -> [String] {
        if textView == nil {
            return []
        }
        return textView.getAllHashTags()
    }

}


//============================================================
//==============     SJUITextView Helper  ====================
//============================================================

extension String {
    func countryName() -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: self) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return self
        }
    }
}


extension UITextView {
    
    func curserPosition() -> NSInteger {
        
        let selectedRange : UITextRange = self.selectedTextRange!
        let textPosition : UITextPosition = selectedRange.start
        return self.offset(from: self.beginningOfDocument, to: textPosition)
    }
    
    func setCurserAtPosition(position : NSInteger) {
        let str : NSString = text as NSString
        if position < str.length {
            let textPosition : UITextPosition = self.position(from: self.beginningOfDocument, offset: position)!
            self.selectedTextRange = self.textRange(from: textPosition, to: textPosition)
        }else{
            let textPosition : UITextPosition = self.position(from: self.beginningOfDocument, offset: str.length)!
            self.selectedTextRange = self.textRange(from: textPosition, to: textPosition)
        }
        
    }
    
    func getCurrentWord() -> String {
        let cursorOffset : NSInteger = self.curserPosition()
        let text : NSString = self.text as NSString
        let substring : NSString = text.substring(to: cursorOffset) as NSString
        var lastWord = substring.components(separatedBy: " ").last
        lastWord = lastWord?.components(separatedBy: "\n").last
        return lastWord!
    }
    
    func getCurrentWordRange() -> NSRange {
        let cursorOffset : NSInteger = self.curserPosition()
        let text : NSString = self.text as NSString
        let substring : NSString = text.substring(to: cursorOffset) as NSString
        
        let endIndex = substring.length
        let lastWord = substring.components(separatedBy: " ").last
        var lastWordStr : NSString = NSString(string: lastWord!)
        var startIndex = endIndex  - lastWordStr.length
        
        if lastWordStr.contains("\n@") == true {
            startIndex += 2
        }else if lastWordStr.contains("\n#") == true {
            startIndex += 2
        }else if lastWordStr.contains("@") == true {
            startIndex += 1
        }else if lastWordStr.contains("#") == true {
            startIndex += 1
        }
        lastWordStr = lastWordStr.replacingOccurrences(of: "@", with: "") as NSString
        lastWordStr = lastWordStr.replacingOccurrences(of: "#", with: "") as NSString
        let wordRange : NSRange = NSMakeRange(startIndex, lastWordStr.length)
        
        return wordRange
    }
    
    
    func getAllAtTags() -> [String] {
        let string = text.replacingOccurrences(of: "\n", with: " ")
        let stringArray = string.components(separatedBy: " ")
        var tagsArray : [String] = []
        for tag in stringArray {
            if tag.hasPrefix("@") || tag.hasPrefix(" @") || tag.hasPrefix("\n@"){
                tagsArray.append(tag)
            }
        }
        
        return tagsArray
    }
    
    func getAllHashTags() -> [String] {
        let string = text.replacingOccurrences(of: "\n", with: " ")
        let stringArray = string.components(separatedBy: " ")
        var tagsArray : [String] = []
        for tag in stringArray {
            if tag.hasPrefix("#") || tag.hasPrefix(" #") || tag.hasPrefix("\n#"){
                tagsArray.append(tag)
            }
        }
        
        return tagsArray
    }
    
    func changeCurrentWordWith(newWordString : NSString) {
        let curserIndex = self.curserPosition()
        let textNSString : NSString = self.text as NSString
//        let preString : NSString = textNSString.substring(to: curserIndex) as NSString
        var startIndex : NSInteger = 0
        for (index, element) in self.text.characters.enumerated() {
            if (element == " " || element == "\n") && curserIndex > index{
                startIndex = index + 1
            }
        }
        
        let nsrange = NSMakeRange(startIndex, curserIndex - startIndex)
        
        if nsrange.location + nsrange.length <= textNSString.length {
            let newString = textNSString.replacingCharacters(in: nsrange, with: newWordString as String)
            
            self.text = newString
            
            self.setCurserAtPosition(position: startIndex + newWordString.length)
        }
        
        
    }
    
    func validateForTagsColor() {
        let curserIndex = self.curserPosition()
        let string : NSMutableAttributedString =  NSMutableAttributedString(string: self.text)
        
        if self.text.isEmpty {
            return
        }
        var startIndex : Int = 0
        repeat {
            let elementOuter = self.text[self.text.index(self.text.startIndex, offsetBy: startIndex)]
            var endIndex : Int = startIndex
            var isFound : Bool = false
            if elementOuter == "@" || elementOuter == "#" {
                repeat {
                    let elementInner = self.text[self.text.index(self.text.startIndex, offsetBy: endIndex)]
                    if elementInner == " " || elementInner == "\n" {
//                        print("Strat Index : ", startIndex, " End Index : ", endIndex, " String Length : ", string.length)
                        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: NSMakeRange(startIndex, endIndex - startIndex))
                        isFound = true
                    }
                    endIndex += 1
                } while endIndex < string.length && isFound == false
                
                
            }
            
            startIndex += 1
        } while startIndex < string.length
        

        
        self.attributedText = string
        self.setCurserAtPosition(position: curserIndex)


    }
    
    
}

//============================================================
//==================     SJUIView Helper  ====================
//============================================================

import Foundation
import UIKit

/**
 *  UIView extension to ease creating Auto Layout Constraints
 */
extension UIView {
    
    
    // MARK: - Fill
    
    /**
     Creates and adds an array of NSLayoutConstraint objects that relates this view's top, leading, bottom and trailing to its superview, given an optional set of insets for each side.
     
     Default parameter values relate this view's top, leading, bottom and trailing to its superview with no insets.
     
     @note The constraints are also added to this view's superview for you
     
     :param: edges An amount insets to apply to the top, leading, bottom and trailing constraint. Default value is UIEdgeInsetsZero
     
     :returns: An array of 4 x NSLayoutConstraint objects (top, leading, bottom, trailing) if the superview exists otherwise an empty array
     */
    @discardableResult
    public func fillSuperView(_ edges: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        
        var constraints: [NSLayoutConstraint] = []
        
        if let superview = superview {
            
            let topConstraint = addTopConstraint(toView: superview, constant: edges.top)
            let leadingConstraint = addLeadingConstraint(toView: superview, constant: edges.left)
            let bottomConstraint = addBottomConstraint(toView: superview, constant: -edges.bottom)
            let trailingConstraint = addTrailingConstraint(toView: superview, constant: -edges.right)
            
            constraints = [topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]
        }
        
        return constraints
    }
    
    
    // MARK: - Leading / Trailing
    
    /**
     Creates and adds an `NSLayoutConstraint` that relates this view's leading edge to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's leading edge to be equal to the leading edge of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's leading edge to e.g. the other view's trailing edge. Default value is `NSLayoutAttribute.Leading`
     
     :param: relation  The relation of the constraint. Default value is `NSLayoutRelation.Equal`
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created `NSLayoutConstraint` for this leading attribute relation
     */
    @discardableResult
    public func addLeadingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .leading, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .leading, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    /**
     Creates and adds an `NSLayoutConstraint` that relates this view's trailing edge to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's trailing edge to be equal to the trailing edge of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's leading edge to e.g. the other view's trailing edge. Default value is `NSLayoutAttribute.Trailing`
     
     :param: relation  The relation of the constraint. Default value is `NSLayoutRelation.Equal`
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created `NSLayoutConstraint` for this trailing attribute relation
     */
    @discardableResult
    public func addTrailingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .trailing, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .trailing, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Left
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's left to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's left to be equal to the left of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's left side to e.g. the other view's right. Default value is NSLayoutAttribute.Left
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created NSLayoutConstraint for this left attribute relation
     */
    @discardableResult
    public func addLeftConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .left, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .left, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Right
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's right to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's right to e.g. the other view's left. Default value is NSLayoutAttribute.Right
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's right from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this right attribute relation
     */
    @discardableResult
    public func addRightConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .right, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .right, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Top
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's top to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's top to e.g. the other view's bottom. Default value is NSLayoutAttribute.Bottom
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's top from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this top edge layout relation
     */
    @discardableResult
    public func addTopConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .top, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .top, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Bottom
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's bottom to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's bottom to e.g. the other view's top. Default value is NSLayoutAttribute.Botom
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's bottom from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this bottom edge layout relation
     */
    @discardableResult
    public func addBottomConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .bottom, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .bottom, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Center X
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's center X attribute to the center X attribute of another view, given a relation and offset.
     Default parameter values relate this view's center X to be equal to the center X of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's center X attribute from the other view's center X attribute. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this center X layout relation
     */
    @discardableResult
    public func addCenterXConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .centerX, toView: view, attribute: .centerX, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Center Y
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's center Y attribute to the center Y attribute of another view, given a relation and offset.
     Default parameter values relate this view's center Y to be equal to the center Y of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's center Y attribute from the other view's center Y attribute. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this center Y layout relation
     */
    @discardableResult
    public func addCenterYConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .centerY, toView: view, attribute: .centerY, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Width
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's width to the width of another view, given a relation and offset.
     Default parameter values relate this view's width to be equal to the width of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's width from the other view's width amount. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this width layout relation
     */
    @discardableResult
    public func addWidthConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .width, toView: view, attribute: .width, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    @discardableResult
    public func addWidthConstraint(widthConstant: CGFloat) -> NSLayoutConstraint {
        
        let constraint =  NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthConstant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }

    
    // MARK: - Height
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's height to the height of another view, given a relation and offset.
     Default parameter values relate this view's height to be equal to the height of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's height from the other view's height amount. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this height layout relation
     */
    @discardableResult
    public func addHeightConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .height, toView: view, attribute: .height, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    @discardableResult
    public func addHeightConstraint(heightConstant: CGFloat) -> NSLayoutConstraint {
        
        let constraint =  NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: heightConstant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }

    // MARK: - Private
    
    /// Adds an NSLayoutConstraint to the superview
    fileprivate func addConstraintToSuperview(_ constraint: NSLayoutConstraint) {
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(constraint)
    }
    
    /// Creates an NSLayoutConstraint using its factory method given both views, attributes a relation and offset
    fileprivate func createConstraint(attribute attr1: NSLayoutAttribute, toView: UIView?, attribute attr2: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attr1,
            relatedBy: relation,
            toItem: toView,
            attribute: attr2,
            multiplier: 1.0,
            constant: constant)
        
        return constraint
    }
}
