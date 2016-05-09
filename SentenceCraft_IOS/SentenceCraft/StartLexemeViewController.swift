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
	
	@IBOutlet private var addTagButton: UIButton!
	@IBOutlet private var removeTagButton: UIButton!
	
	// Field to take user input for new lexeme
	@IBOutlet private var lexemeField: UITextView!
	
	// Button to submit new lexeme
	@IBOutlet private var submitButton: UIButton!
	
	// global variable
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	var tags: [String] = []
	var tagsListString: String = String()
	
	private var tagLabel: UITextView!
	
	// Create the tags and their placeholders for the user
	func createTags() {
		
		// Create TextField to type new tags into
		tag = UITextField.init(frame: CGRectMake(20, 0, 100, 50))
		tag.center = CGPointMake(tag.center.x, tag.frame.height + (self.navigationController?.navigationBar.frame.height)!)
		tag.placeholder = "Tag"
		tag.borderStyle = UITextBorderStyle.Line
		tag.keyboardType = UIKeyboardType.Default
		tag.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		tag.autocorrectionType = UITextAutocorrectionType.No
		tag.autocapitalizationType = UITextAutocapitalizationType.None
		self.view.addSubview(tag)
		
		// Button that adds the new tag
		addTagButton = UIButton.init(type: UIButtonType.RoundedRect)
		addTagButton.setTitle("Add Tag", forState: UIControlState.Normal)
		addTagButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		addTagButton.backgroundColor = UIColor(netHex: 0x18bc9c)
		addTagButton.frame = CGRectMake(tag.frame.minX, 0, 125, 50)
		addTagButton.center = CGPointMake(addTagButton.center.x, tag.frame.maxY + tag.frame.height)
		addTagButton.layer.cornerRadius = 10
		addTagButton.layer.borderWidth = 5
		addTagButton.layer.borderColor = addTagButton.backgroundColor!.CGColor
		addTagButton.addTarget(self,
		                       action: #selector(StartLexemeViewController.addTagButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(addTagButton)
		
		// Button that removes that last tag
		removeTagButton = UIButton.init(type: UIButtonType.RoundedRect)
		removeTagButton.setTitle("Remove Tag", forState: UIControlState.Normal)
		removeTagButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		removeTagButton.backgroundColor = UIColor(netHex: 0xe74c3c)
		removeTagButton.frame = CGRectMake(0, addTagButton.frame.minY, 125, 50)
		removeTagButton.center = CGPointMake(addTagButton.frame.maxX + 50 + removeTagButton.frame.width/2, removeTagButton.center.y)
		removeTagButton.layer.cornerRadius = 10
		removeTagButton.layer.borderWidth = 5
		removeTagButton.layer.borderColor = removeTagButton.backgroundColor!.CGColor
		removeTagButton.addTarget(self,
		                          action: #selector(StartLexemeViewController.removeTagButtonPressed(_:)),
		                          forControlEvents: UIControlEvents.TouchUpInside)

		self.view.addSubview(removeTagButton)
		
		// Label that lists all added tags
		tagLabel = UITextView.init(frame: CGRectMake(20, 0, self.view.frame.width - 40, 100))
		tagLabel.text = "Tags: \(tagsListString)"
		tagLabel.font = UIFont(name: tag.font!.fontName, size: 25)
		tagLabel.center = CGPointMake(tagLabel.center.x, addTagButton.frame.maxY + 3 * addTagButton.frame.height/2)
		tagLabel.editable = false
		tagLabel.textAlignment = NSTextAlignment.Left
		self.view.addSubview(tagLabel)
	}
	
	
	// Create text field to recieve user input for lexeme
	func createLexemeField() {
		let lexemeLabel: UILabel = UILabel.init(frame: CGRectMake(20, 0, 150, 50))
		lexemeLabel.text = "Lexeme:"
		lexemeLabel.font = UIFont(name: lexemeLabel.font.fontName, size: 25)
		lexemeLabel.center = CGPointMake(lexemeLabel.center.x, self.view.center.y)
		lexemeLabel.textAlignment = NSTextAlignment.Left
		self.view.addSubview(lexemeLabel)
		
		lexemeField = UITextView.init(frame: CGRectMake(20, lexemeLabel.frame.maxY, self.view.frame.width - 40, 175))
		lexemeField.keyboardType = UIKeyboardType.Default
		lexemeField.layer.borderWidth = 3
		lexemeField.layer.borderColor = UIColor.blackColor().CGColor
		lexemeField.autocapitalizationType = UITextAutocapitalizationType.None
		lexemeField.font = UIFont(name: (lexemeLabel.font.fontName), size: 25)
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
	
	// When the Add Tag button is pressed, add it to the array
	// and update the tags string
	func addTagButtonPressed(sender: UIButton!) {
		let newTag = tag.text!
		if !newTag.isEmpty {
			tags.append(newTag)
		}
		tag.text = ""
		tagsListString = ""
		for t in tags {
			tagsListString += t
			if t != tags.last {
				tagsListString += ","
			}
		}
		tagLabel.text = "Tags: \(tagsListString)"
	}
	
	// When the Remove Tag button is pressed, remove the last tag from the array
	// and update the tags string
	func removeTagButtonPressed(sender: UIButton!) {
		if tags.endIndex <= 0 {
			return
		}
		tags.removeLast()
		tagsListString = ""
		for t in tags {
			tagsListString += t
			if t != tags.last {
				tagsListString += ","
			}
		}
		tagLabel.text = "Tags: \(tagsListString)"
	}
	
	
	// When the submit button is pressed, send the new lexeme to the API server and
	// go back to the main page
	func submitButtonPressed(sender: UIButton!) {
		let message = appDelegate.server.sendStartSentenceRequest(tagsListString, sentence: lexemeField.text!,
		                                            type: appDelegate.sentence_or_word_lexeme)
		tags.removeAll()
		tagsListString = ""
		
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