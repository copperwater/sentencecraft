//
//  StartLexemeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/7/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class StartLexemeViewController: UIViewController {
	
	// Tags for the user to add for a lexeme
	@IBOutlet private var tag: UITextField!
	
	@IBOutlet private var addLexemeButton: UIButton!
	@IBOutlet private var removeLexemeButton: UIButton!
	
	// Field to take user input for new lexeme
	@IBOutlet private var lexemeField: UITextView!
	
	// Button to submit new lexeme
	@IBOutlet private var submitButton: UIButton!
	
	// global variable
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	var tags: [String] = []
	var tagsStringList: String = String()
	
	private var tagLabel: UITextView!
	
	// Create the tags and their placeholders for the user
	func createTags() {
		
		// Create first tag
		tag = UITextField.init(frame: CGRectMake(20, 0, 100, 50))
		tag.center = CGPointMake(tag.center.x, tag.frame.height + (self.navigationController?.navigationBar.frame.height)!)
		tag.placeholder = "Tag"
		tag.borderStyle = UITextBorderStyle.Line
		tag.keyboardType = UIKeyboardType.Default
		tag.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tag.autocorrectionType = UITextAutocorrectionType.No
		tag.autocapitalizationType = UITextAutocapitalizationType.None
		self.view.addSubview(tag)
		
		addLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		addLexemeButton.setTitle("Add tag", forState: UIControlState.Normal)
		addLexemeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		addLexemeButton.backgroundColor = UIColor(netHex: 0x18bc9c)
		addLexemeButton.frame = CGRectMake(tag.frame.minX, 0, 125, 50)
		addLexemeButton.center = CGPointMake(addLexemeButton.center.x, tag.frame.maxY + tag.frame.height)
		addLexemeButton.layer.cornerRadius = 10
		addLexemeButton.layer.borderWidth = 5
		addLexemeButton.layer.borderColor = addLexemeButton.backgroundColor!.CGColor
		addLexemeButton.addTarget(self,
		                       action: #selector(StartLexemeViewController.addLexemeButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(addLexemeButton)
		
		
		removeLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		removeLexemeButton.setTitle("Remove tag", forState: UIControlState.Normal)
		removeLexemeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		removeLexemeButton.backgroundColor = UIColor(netHex: 0xe74c3c)
		removeLexemeButton.frame = CGRectMake(0, addLexemeButton.frame.minY, 125, 50)
		removeLexemeButton.center = CGPointMake(addLexemeButton.frame.maxX + 50 + removeLexemeButton.frame.width/2, removeLexemeButton.center.y)
		removeLexemeButton.layer.cornerRadius = 10
		removeLexemeButton.layer.borderWidth = 5
		removeLexemeButton.layer.borderColor = removeLexemeButton.backgroundColor!.CGColor
		removeLexemeButton.addTarget(self,
		                          action: #selector(StartLexemeViewController.removeLexemeButtonPressed(_:)),
		                          forControlEvents: UIControlEvents.TouchUpInside)

		self.view.addSubview(removeLexemeButton)
		
		// Label that says "Tags:"
		tagLabel = UITextView.init(frame: CGRectMake(20, 0, self.view.frame.width - 40, 100))
		tagLabel.text = "Tags: \(tagsStringList)"
		tagLabel.font = UIFont(name: tag.font!.fontName, size: 25)
		tagLabel.center = CGPointMake(tagLabel.center.x, addLexemeButton.frame.maxY + 3 * addLexemeButton.frame.height/2)
		tagLabel.editable = false
		tagLabel.textAlignment = NSTextAlignment.Left
		self.view.addSubview(tagLabel)
	}
	
	
	// Create text field to recieve user input for lexeme
	func createLexemeField() {
		let lexemeFieldTag: UILabel = UILabel.init(frame: CGRectMake(20, 0, 150, 50))
		lexemeFieldTag.text = "Lexeme:"
		lexemeFieldTag.font = UIFont(name: lexemeFieldTag.font.fontName, size: 25)
		lexemeFieldTag.center = CGPointMake(lexemeFieldTag.center.x, self.view.center.y)
		lexemeFieldTag.textAlignment = NSTextAlignment.Left
		self.view.addSubview(lexemeFieldTag)
		
		lexemeField = UITextView.init(frame: CGRectMake(20, lexemeFieldTag.center.y + lexemeFieldTag.frame.height/2, self.view.frame.width - 40, 175))
		lexemeField.keyboardType = UIKeyboardType.Default
		lexemeField.layer.borderWidth = 3
		lexemeField.layer.borderColor = UIColor.blackColor().CGColor
		lexemeField.autocapitalizationType = UITextAutocapitalizationType.None
		lexemeField.font = UIFont(name: (lexemeFieldTag.font.fontName), size: 25)
		self.view.addSubview(lexemeField)
	}
	
	// Create the button to submit the nex lexeme
	func createSubmitButton() {
		submitButton = UIButton.init(type: UIButtonType.RoundedRect)
		submitButton.setTitle("Submit", forState: UIControlState.Normal)
		submitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		submitButton.backgroundColor = UIColor(netHex: 0x3498db)
		submitButton.frame = CGRectMake(0, 0, 200, 50)
		submitButton.center = CGPointMake(self.view.frame.width - submitButton.frame.width/2 - 20,
		                                  self.view.frame.height - submitButton.frame.height/2 - 20)
		submitButton.titleLabel!.font =
			UIFont(name: submitButton.titleLabel!.font!.fontName,
			       size: 25)
		submitButton.layer.cornerRadius = 10
		submitButton.layer.borderWidth = 5
		submitButton.layer.borderColor = submitButton.backgroundColor!.CGColor
		submitButton.addTarget(self,
		                       action: #selector(StartLexemeViewController.submitButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(submitButton)

	}
	
	func addLexemeButtonPressed(sender: UIButton!) {
		let newTag = tag.text!
		if !newTag.isEmpty {
			tags.append(newTag)
		}
		tag.text = ""
		tagsStringList = ""
		for t in tags {
			tagsStringList += t
			if t != tags.last {
				tagsStringList += ","
			}
		}
		tagLabel.text = "Tags: \(tagsStringList)"
	}
	
	
	func removeLexemeButtonPressed(sender: UIButton!) {
		if tags.endIndex <= 0 {
			return
		}
		tags.removeLast()
		tagsStringList = ""
		for t in tags {
			tagsStringList += t
			if t != tags.last {
				tagsStringList += ","
			}
		}
		tagLabel.text = "Tags: \(tagsStringList)"
	}
	
	
	// When the submit button is pressed, send the new lexeme to the API server and
	// go back to the main page
	func submitButtonPressed(sender: UIButton!) {
		let message = appDelegate.server.sendStartSentenceRequest(tagsStringList, sentence: lexemeField.text!,
		                                            type: appDelegate.sentence_or_word_lexeme)
		tags.removeAll()
		tagsStringList = ""
		
		navigationController?.popViewControllerAnimated(true)
		
		let alert: UIAlertView = UIAlertView(title: "Start Lexeme:", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
		alert.show()
		
	}

	// Load the StartLexemeViewController view
	override func viewDidLoad() {
		super.viewDidLoad()
		createTags()
		createLexemeField()
		createSubmitButton()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}