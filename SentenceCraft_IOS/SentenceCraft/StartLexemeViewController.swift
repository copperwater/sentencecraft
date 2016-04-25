//
//  StartLexemeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/7/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class StartLexemeViewController: UIViewController {
	
	@IBOutlet private var tagOne: UITextField!
	@IBOutlet private var tagTwo: UITextField!
	@IBOutlet private var tagThree: UITextField!
	@IBOutlet private var tagFour: UITextField!
	
	@IBOutlet private var lexemeField: UITextField!
	
	@IBOutlet private var submitButton: UIButton!
	var server: ServerRequest!
	
	func createTags() {
		let tagLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 150, 50))
		tagLabel.text = "Tags:"
		tagLabel.font = UIFont(name: tagLabel.font.fontName, size: 25)
		tagLabel.center = CGPointMake(tagLabel.center.x, tagLabel.frame.width/2)
		tagLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(tagLabel)
		
		
		tagOne = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagOne.center = CGPointMake(tagLabel.center.x, tagLabel.center.y + 3*tagLabel.frame.height/2)
		tagOne.placeholder = "tag"
		tagOne.borderStyle = UITextBorderStyle.RoundedRect
		tagOne.keyboardType = UIKeyboardType.Default
		tagOne.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		self.view.addSubview(tagOne)
		
		tagTwo = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagTwo.center = CGPointMake(tagOne.center.x + tagOne.frame.width/2 + 50, tagOne.center.y)
		tagTwo.placeholder = "tag"
		tagTwo.borderStyle = UITextBorderStyle.RoundedRect
		tagTwo.keyboardType = UIKeyboardType.Default
		tagTwo.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		self.view.addSubview(tagTwo)
		
		tagThree = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagThree.center = CGPointMake(tagTwo.center.x + tagTwo.frame.width/2 + 50, tagOne.center.y)
		tagThree.placeholder = "tag"
		tagThree.borderStyle = UITextBorderStyle.RoundedRect
		tagThree.keyboardType = UIKeyboardType.Default
		tagThree.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		self.view.addSubview(tagThree)
		
		tagFour = UITextField.init(frame: CGRectMake(0, 0, 75, 50))
		tagFour.center = CGPointMake(tagThree.center.x + tagThree.frame.width/2 + 50, tagOne.center.y)
		tagFour.placeholder = "tag"
		tagFour.borderStyle = UITextBorderStyle.RoundedRect
		tagFour.keyboardType = UIKeyboardType.Default
		tagFour.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		self.view.addSubview(tagFour)

	}
	
	
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
	
	func submitButtonPressed(sender: UIButton!) {
		let tags = tagOne.text! + ", " + tagTwo.text!
		server.sendStartSentenceRequest(tags, sentence: lexemeField.text!)
		navigationController?.popViewControllerAnimated(true)
		
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.server = ServerRequest.init()
		createTags()
		createLexemeField()
		createSubmitButton()
//		self.navigationController?.navigationBar.topItem?.title = "Create Lexeme"
//		self.navigationController?.setNavigationBarHidden(false, animated: true)
//		self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}