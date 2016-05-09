//
//  LexemeModeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/28/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class LexemeModeViewController: UIViewController {
	
	
	let modes: [String] = ["Sentence", "Paragraph"]
	
	var modeLabel: UILabel!
	var modeSegmentedControl: UISegmentedControl!
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	// Creates the label to say which mode to select for lexeme
	func createLexemeMode() {
		modeLabel = UILabel.init(frame: CGRectMake(0, 0, 175, 50))
		modeLabel.text = "Lexeme Mode:"
		modeLabel.font = UIFont(name: modeLabel.font.fontName, size: 20)
		modeLabel.center = CGPointMake(95, self.view.frame.height/3)
		modeLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(modeLabel)
	}
	
	func createModeSegmentedControl() {
		modeSegmentedControl = UISegmentedControl.init(items: modes)
		modeSegmentedControl.frame = CGRectMake(modeLabel.frame.maxX, 0, 175, 45)
		modeSegmentedControl.center = CGPointMake(modeSegmentedControl.center.x, modeLabel.center.y)

		if appDelegate.sentence_or_word_lexeme == "word" {
			modeSegmentedControl.selectedSegmentIndex = 0
		} else {
			modeSegmentedControl.selectedSegmentIndex = 1
		}
		
		modeSegmentedControl.addTarget(self,
		                         action: #selector(LexemeModeViewController.lexemeModeChanged(_:)),
		                         forControlEvents: UIControlEvents.ValueChanged)
		
		self.view.addSubview(modeSegmentedControl!)
	}
	
	func lexemeModeChanged(sender: UISegmentedControl) {
		if modeSegmentedControl.selectedSegmentIndex == 0 {
			appDelegate.sentence_or_word_lexeme = "word"
		} else {
			appDelegate.sentence_or_word_lexeme = "sentence"
		}
	}
	
	// Load the settings page
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createLexemeMode()
		self.createModeSegmentedControl()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
