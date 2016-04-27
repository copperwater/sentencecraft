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
	
	@IBOutlet private var submitButton: UIButton!
	
	var server: ServerRequest = ServerRequest.init()
	
	var lexeme: [String: AnyObject] = [:]
	
	
	func createLexemeInfo() {
		let tagsInfo: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 50))
		tagsInfo.text = "Tags: food, happiness"
		tagsInfo.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		tagsInfo.center = CGPointMake(tagsInfo.center.x, tagsInfo.frame.width/3)
		tagsInfo.textAlignment = NSTextAlignment.Center
		self.view.addSubview(tagsInfo)
		
		let lexemeText: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 150))
		lexemeText.text = "So far: ...I love to eat"
		lexemeText.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		lexemeText.center = CGPointMake(lexemeText.center.x, tagsInfo.center.y + tagsInfo.frame.height)
		lexemeText.textAlignment = NSTextAlignment.Center
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
		self.view.addSubview(submitButton)
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createLexemeInfo()
		createLexemeField()
		createSubmitButton()
		lexeme = server.requestIncompleteLexeme()!
//		self.navigationController?.navigationBar.topItem?.title = "Continue Lexeme"
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}


