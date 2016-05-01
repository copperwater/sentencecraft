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
	@IBOutlet private var tagOne: UITextField!
	@IBOutlet private var tagTwo: UITextField!
	@IBOutlet private var tagThree: UITextField!
	@IBOutlet private var tagFour: UITextField!
	
	// Field to take user input for new lexeme
	@IBOutlet private var lexemeField: UITextField!
	
	// Button to submit new lexeme
	@IBOutlet private var submitButton: UIButton!
	
	// global variable
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	
	// Create the tags and their placeholders for the user
	func createTags() {
		// Label that says "Tags:"
		let tagLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 150, 50))
		tagLabel.text = "Tags:"
		tagLabel.font = UIFont(name: tagLabel.font.fontName, size: 25)
		tagLabel.center = CGPointMake(tagLabel.center.x, tagLabel.frame.width/2)
		tagLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(tagLabel)
		
		// Create first tag
		tagOne = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagOne.center = CGPointMake(tagLabel.center.x, tagLabel.center.y + 3*tagLabel.frame.height/2)
		tagOne.placeholder = "tag"
		tagOne.borderStyle = UITextBorderStyle.RoundedRect
		tagOne.keyboardType = UIKeyboardType.Default
		tagOne.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tagOne.autocorrectionType = UITextAutocorrectionType.No
		self.view.addSubview(tagOne)
		
		// Create second tag
		tagTwo = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagTwo.center = CGPointMake(tagOne.center.x + tagOne.frame.width/2 + 50, tagOne.center.y)
		tagTwo.placeholder = "tag"
		tagTwo.borderStyle = UITextBorderStyle.RoundedRect
		tagTwo.keyboardType = UIKeyboardType.Default
		tagTwo.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tagTwo.autocorrectionType = UITextAutocorrectionType.No
		self.view.addSubview(tagTwo)
		
		// Create third tag
		tagThree = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagThree.center = CGPointMake(tagTwo.center.x + tagTwo.frame.width/2 + 50, tagOne.center.y)
		tagThree.placeholder = "tag"
		tagThree.borderStyle = UITextBorderStyle.RoundedRect
		tagThree.keyboardType = UIKeyboardType.Default
		tagThree.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tagThree.autocorrectionType = UITextAutocorrectionType.No
		self.view.addSubview(tagThree)
		
		// Create fourth tag
		tagFour = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagFour.center = CGPointMake(tagThree.center.x + tagThree.frame.width/2 + 50, tagOne.center.y)
		tagFour.placeholder = "tag"
		tagFour.borderStyle = UITextBorderStyle.RoundedRect
		tagFour.keyboardType = UIKeyboardType.Default
		tagFour.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tagFour.autocorrectionType = UITextAutocorrectionType.No
		self.view.addSubview(tagFour)

	}
	
	
	// Create text field to recieve user input for lexeme
	func createLexemeField() {
		let lexemeFieldTag: UILabel = UILabel.init(frame: CGRectMake(0, 0, 150, 50))
		lexemeFieldTag.text = "Lexeme:"
		lexemeFieldTag.font = UIFont(name: lexemeFieldTag.font.fontName, size: 25)
		lexemeFieldTag.center = CGPointMake(tagOne.center.x, self.view.center.y)
		lexemeFieldTag.textAlignment = NSTextAlignment.Center
		self.view.addSubview(lexemeFieldTag)
		
		lexemeField = UITextField.init(frame: CGRectMake(12, lexemeFieldTag.center.y + lexemeFieldTag.frame.height/2, self.view.frame.width - 24, 175))
		lexemeField.placeholder = "Lexeme"
		lexemeField.keyboardType = UIKeyboardType.Default
		lexemeField.borderStyle = UITextBorderStyle.Line
		lexemeField.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
		lexemeField.font = UIFont(name: (lexemeField.font?.fontName)!, size: 25)
		self.view.addSubview(lexemeField)
	}
	
	// Create the button to submit the nex lexeme
	func createSubmitButton() {
		submitButton = UIButton.init(type: UIButtonType.RoundedRect)
		submitButton.setTitle("Submit", forState: UIControlState.Normal)
		submitButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		submitButton.frame = CGRectMake(0, 0, 200, 50)
		submitButton.center = CGPointMake(self.view.frame.width - submitButton.frame.width/2 - 20,
		                                  self.view.frame.height - submitButton.frame.height/2 - 20)
		submitButton.layer.cornerRadius = 10
		submitButton.layer.borderWidth = 5
		submitButton.layer.borderColor = UIColor.blueColor().CGColor
		submitButton.addTarget(self,
		                       action: #selector(StartLexemeViewController.submitButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(submitButton)

	}
	
	// When the submit button is pressed, send the new lexeme to the API server and
	// go back to the main page
	func submitButtonPressed(sender: UIButton!) {
		let tags = tagOne.text!
		appDelegate.server.sendStartSentenceRequest(tags, sentence: lexemeField.text!,
		                                            type: appDelegate.sentence_or_word_lexeme)
		navigationController?.popViewControllerAnimated(true)
		
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