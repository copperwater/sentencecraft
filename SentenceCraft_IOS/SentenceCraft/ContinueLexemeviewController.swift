//
//  ContinueLexemeviewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

// This is a View and Controller since it is used by the User by manipulating the
// ServerRequest model while also showing the View for the User to interact with

class ContinueLexemeViewController: UIViewController {
	
	// Field to append to the lexeme
	@IBOutlet private var lexemeField: UITextView!
	
	// Buttons that indicate either complete or continue the current lexeme
	@IBOutlet private var completeButton: UIButton!
	@IBOutlet private var continueButton: UIButton!
	
	// Global variables
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	// Collection that stores the info that was passed in from the server
	var lexeme: [String: AnyObject] = [:]
	
	// Array that will hold all the parts of the lexeme passed from the server
	var lexemeParts: [String] = []
	
	// Comma separated string of the tags for the given lexeme
	var tags: String = String()
	
	// Separate the information from the dictionary into usable information
	func parseInfoFromDict() {
		lexemeParts = lexeme["lexemecollection"]!["lexemes"] as! [String]
		
		if lexeme["lexemecollection"]!["tags"] === nil {
			return
		}
		for tag in (lexeme["lexemecollection"]!["tags"] as! [String]) {
			tags += tag
			if tag != (lexeme["lexemecollection"]!["tags"] as! [String]).last {
				tags += ", "
			}
		}
	}
	
	// Get the last 3 portions of the lexeme to display to the user
	func lastThreeLexemeParts() -> String {
		var ret: String = String()
		var i: Int = max(lexemeParts.endIndex - 3, 0)
		if i > 0 {
			ret += "... "
		}
		
		while i < lexemeParts.endIndex {
			ret += lexemeParts[i]
			ret += " "
			i += 1
		}
		
		return ret
	}
	
	// Create the tags and text that will show the user the lexeme that was given to them
	func createLexemeInfo() {
		// Create the tags for the lexeme
		let tagsInfo: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 50))
		tagsInfo.text = "Tags: \(tags)"
		tagsInfo.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		tagsInfo.center = CGPointMake(tagsInfo.center.x, tagsInfo.frame.width/3)
		self.view.addSubview(tagsInfo)
		
		// Create the last 3 portions of the lexeme that are shown
		let lexemeText: UITextView = UITextView.init(frame: CGRectMake(0, 0, self.view.frame.width, 150))
		lexemeText.text = "\(lastThreeLexemeParts())"
		lexemeText.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		lexemeText.editable = false
		lexemeText.center = CGPointMake(lexemeText.center.x, tagsInfo.center.y + 3*tagsInfo.frame.height)
		lexemeText.textAlignment = NSTextAlignment.Center
		self.view.addSubview(lexemeText)
	}
	
	// Create the textfield for the user to input their appendage for the lexeme
	func createLexemeField() {
		let lexemeLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 150, 50))
		lexemeLabel.text = "Lexeme:"
		lexemeLabel.font = UIFont(name: lexemeLabel.font.fontName, size: 25)
		lexemeLabel.center = CGPointMake(lexemeLabel.center.x, self.view.center.y)
		lexemeLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(lexemeLabel)
		
		lexemeField = UITextView.init(frame: CGRectMake(12, lexemeLabel.frame.maxY, self.view.frame.width - 24, 175))
		lexemeField.autocapitalizationType = UITextAutocapitalizationType.None
		lexemeField.keyboardType = UIKeyboardType.Default
		lexemeField.layer.borderWidth = 3
		lexemeField.font = UIFont(name: lexemeLabel.font.fontName, size: 25)
		self.view.addSubview(lexemeField)
	}
	
	// Create the button that will submit a request to continue the lexeme with the appendage
	func createContinueButton() {
		continueButton = UIButton.init(type: UIButtonType.RoundedRect)
		continueButton.setTitle("Continue", forState: UIControlState.Normal)
		continueButton.backgroundColor = UIColor(netHex: 0x3498db)
		continueButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		continueButton.frame = CGRectMake(0, 0, 150, 50)
		continueButton.center = CGPointMake(continueButton.frame.width/2 + 20,
		                                    self.view.frame.height - continueButton.frame.height/2 - 20)
		continueButton.titleLabel!.font =
			UIFont(name: continueButton.titleLabel!.font!.fontName,
			       size: 25)
		continueButton.layer.cornerRadius = 10
		continueButton.layer.borderWidth = 5
		continueButton.layer.borderColor = continueButton.backgroundColor!.CGColor
		continueButton.addTarget(self,
		                         action: #selector(ContinueLexemeViewController.continueButtonPressed(_:)),
		                         forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(continueButton)
	}
	
	// Create the button that will submit a request to complete the lexeme with the appendage
	func createCompleteButton() {
		completeButton = UIButton.init(type: UIButtonType.RoundedRect)
		completeButton.setTitle("Complete", forState: UIControlState.Normal)
		completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		completeButton.backgroundColor = UIColor(netHex: 0x3498db)
		completeButton.frame = CGRectMake(0, 0, 150, 50)
		completeButton.center = CGPointMake(self.view.frame.width - completeButton.frame.width/2 - 20,
		                                  self.view.frame.height - completeButton.frame.height/2 - 20)
		completeButton.titleLabel!.font =
			UIFont(name: completeButton.titleLabel!.font!.fontName,
			       size: 25)
		completeButton.layer.cornerRadius = 10
		completeButton.layer.borderWidth = 5
		completeButton.layer.borderColor = completeButton.backgroundColor!.CGColor
		completeButton.addTarget(self,
		                       action: #selector(ContinueLexemeViewController.completeButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(completeButton)
	}
	
	// Function that will send the user input to the server API if they pressed the continue button
	func continueButtonPressed(sender: UIButton!) {
		let message = appDelegate.server.sendAppendRequest(lexemeField.text!, key: (lexeme["key"] as! String),
		                                     action: "false", type: appDelegate.sentence_or_word_lexeme)

		navigationController?.popViewControllerAnimated(true)
		
		let alert: UIAlertView = UIAlertView(title: "Continue/Complete Lexeme:", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
		alert.show()

	}
	
	// Function that will send the user input to the server API if they pressed the complete button
	func completeButtonPressed(sender: UIButton!) {
		
		let message = appDelegate.server.sendAppendRequest(lexemeField.text!, key: (lexeme["key"] as! String),
		                                     action: "true", type: appDelegate.sentence_or_word_lexeme)

		navigationController?.popViewControllerAnimated(true)
		
		let alert: UIAlertView = UIAlertView(title: "Continue/Complete Lexeme:", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
		alert.show()

	}
	
	// Function that loads the ContinueLexemeViewController
	override func viewDidLoad() {
		super.viewDidLoad()
		createCompleteButton()
		createContinueButton()
		lexeme = appDelegate.server.requestIncompleteLexeme(appDelegate.sentence_or_word_lexeme)!
		if lexeme.isEmpty {
			
			navigationController?.popViewControllerAnimated(true)

			let alert: UIAlertView = UIAlertView(title: "Continue Lexeme:", message: "There are no lexemes to continue in the server. Consider starting one.", delegate: self, cancelButtonTitle: "Ok")
			alert.show()
			
		} else {
			self.parseInfoFromDict()
			createLexemeInfo()
			createLexemeField()
		}
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}


