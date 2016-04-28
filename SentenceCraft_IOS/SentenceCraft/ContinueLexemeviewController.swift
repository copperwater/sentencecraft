//
//  ContinueLexemeviewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class ContinueLexemeViewController: UIViewController {
	
	@IBOutlet private var lexemeField: UITextField!
	
	@IBOutlet private var completeButton: UIButton!
	
	@IBOutlet private var continueButton: UIButton!
	
	var server: ServerRequest = ServerRequest.init()
	
	var lexeme: [String: AnyObject] = [:]
	
	var lexemeParts: [String] = []
	var tags: String = String()
	
	
	func parseInfoFromDict() {
		lexemeParts = lexeme["lexemecollection"]!["lexemes"] as! [String]
		print(lexemeParts)

		
		print(lexeme["lexemecollection"]!["tags"])
		if lexeme["lexemecollection"]!["tags"] === nil {
			return
		}
		for tag in (lexeme["lexemecollection"]!["tags"] as! [String]) {
			tags += tag
			tags += ", "
		}
		print(tags)
	}
	
	func lastThreeLexemeParts() -> String {
		var ret: String = String()
		var i: Int = max(lexemeParts.endIndex - 4, 0)
		while i < lexemeParts.endIndex {
			ret += lexemeParts[i]
			ret += " "
			i += 1
		}
//		print ret
		return ret
	}
	
	func createLexemeInfo() {
		let tagsInfo: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 50))
		tagsInfo.text = "Tags: \(tags)"
		tagsInfo.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		tagsInfo.center = CGPointMake(tagsInfo.center.x, tagsInfo.frame.width/3)
		tagsInfo.textAlignment = NSTextAlignment.Center
		self.view.addSubview(tagsInfo)
		
		let lexemeText: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 150))
		lexemeText.text = "So far: ... \(lastThreeLexemeParts())"
		lexemeText.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		lexemeText.center = CGPointMake(lexemeText.center.x, tagsInfo.center.y + 2*tagsInfo.frame.height)
		lexemeText.textAlignment = NSTextAlignment.Center
		lexemeText.numberOfLines = 0
		lexemeText.lineBreakMode = NSLineBreakMode.ByWordWrapping
		self.view.addSubview(lexemeText)
	}
	
	func createLexemeField() {
		let lexemeFieldTag: UILabel = UILabel.init(frame: CGRectMake(0, 0, 150, 50))
		lexemeFieldTag.text = "Lexeme:"
		lexemeFieldTag.font = UIFont(name: lexemeFieldTag.font.fontName, size: 25)
		lexemeFieldTag.center = CGPointMake(lexemeFieldTag.center.x, self.view.center.y)
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
	
	
	func createContinueButton() {
		continueButton = UIButton.init(type: UIButtonType.RoundedRect)
		continueButton.setTitle("Continue", forState: UIControlState.Normal)
		continueButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		continueButton.frame = CGRectMake(0, 0, 200, 50)
		continueButton.center = CGPointMake(continueButton.frame.width/2 + 20,
		                                    self.view.frame.height - continueButton.frame.height/2 - 20)
		continueButton.layer.cornerRadius = 10
		continueButton.layer.borderWidth = 5
		continueButton.layer.borderColor = UIColor.blueColor().CGColor
		continueButton.addTarget(self,
		                         action: #selector(ContinueLexemeViewController.continueButtonPressed(_:)),
		                         forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(continueButton)
	}
	
	func createCompleteButton() {
		completeButton = UIButton.init(type: UIButtonType.RoundedRect)
		completeButton.setTitle("Complete", forState: UIControlState.Normal)
		completeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		completeButton.frame = CGRectMake(0, 0, 200, 50)
		completeButton.center = CGPointMake(self.view.frame.width - completeButton.frame.width/2 - 20,
		                                  self.view.frame.height - completeButton.frame.height/2 - 20)
		completeButton.layer.cornerRadius = 10
		completeButton.layer.borderWidth = 5
		completeButton.layer.borderColor = UIColor.blueColor().CGColor
		completeButton.addTarget(self,
		                       action: #selector(ContinueLexemeViewController.completeButtonPressed(_:)),
		                       forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(completeButton)
	}
	
	func continueButtonPressed(sender: UIButton!) {
		server.sendAppendRequest(lexemeField.text!, key: (lexeme["key"] as! String), action: "false")
		navigationController?.popViewControllerAnimated(true)
	}
	
	func completeButtonPressed(sender: UIButton!) {
		server.sendAppendRequest(lexemeField.text!, key: (lexeme["key"] as! String), action: "true")
		navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createCompleteButton()
		createContinueButton()
		lexeme = server.requestIncompleteLexeme()!
		self.parseInfoFromDict()
		createLexemeInfo()
		createLexemeField()
//		self.navigationController?.navigationBar.topItem?.title = "Continue Lexeme"
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}


