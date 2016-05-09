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
	
	// Field to take user input for new lexeme
	@IBOutlet private var lexemeField: UITextView!
	
	// Button to submit new lexeme
	@IBOutlet private var submitButton: UIButton!
	
	// global variable
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	var tags: [String] = []
	
	// Create the tags and their placeholders for the user
	func createTags() {
		// Label that says "Tags:"
		let tagLabel: UILabel = UILabel.init(frame: CGRectMake(20, 0, 150, 50))
		tagLabel.text = "Tags:"
		tagLabel.font = UIFont(name: tagLabel.font.fontName, size: 25)
		tagLabel.center = CGPointMake(tagLabel.center.x, tagLabel.frame.height + (self.navigationController?.navigationBar.frame.height)!)
		tagLabel.textAlignment = NSTextAlignment.Left
		self.view.addSubview(tagLabel)
		
		// Create first tag
		tag = UITextField.init(frame: CGRectMake(0, 0, 100, 50))
		tag.center = CGPointMake(tagLabel.center.x, tagLabel.frame.maxY + 3 * tagLabel.frame.height/2)
		tag.placeholder = "Tag"
		tag.borderStyle = UITextBorderStyle.Line
		tag.keyboardType = UIKeyboardType.Default
		tag.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tag.autocorrectionType = UITextAutocorrectionType.No
		tag.autocapitalizationType = UITextAutocapitalizationType.None
		self.view.addSubview(tag)
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
		let tags = tag.text!
		let message = appDelegate.server.sendStartSentenceRequest(tags, sentence: lexemeField.text!,
		                                            type: appDelegate.sentence_or_word_lexeme)
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