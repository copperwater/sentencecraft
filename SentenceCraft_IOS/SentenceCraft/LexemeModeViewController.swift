//
//  LexemeModeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/28/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

// This is a View and Controller since it is used by the User by manipulating the
// ServerRequest model while also showing the View for the User to interact with

class LexemeModeViewController: UIViewController {
	
	
	let modes: [String] = ["Sentence", "Paragraph"]
	let servers: [String] = ["Local", "Remote"]
	
	var modeLabel: UILabel!
	@IBOutlet var modeSegmentedControl: UISegmentedControl!
	
	var serverLabel: UILabel!
	@IBOutlet var serverSegmentedControl: UISegmentedControl!
	
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
	
	// Creates segmented control that lets user choose between lexeme modes
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
	
	// Respond when the user changes the lexeme mode
	func lexemeModeChanged(sender: UISegmentedControl) {
		if modeSegmentedControl.selectedSegmentIndex == 0 {
			appDelegate.sentence_or_word_lexeme = "word"
		} else {
			appDelegate.sentence_or_word_lexeme = "sentence"
		}
	}
	

	// Creates the label to say which mode to select for server
	func createServerMode() {
		serverLabel = UILabel.init(frame: CGRectMake(0, 0, 175, 50))
		serverLabel.text = "Server Connection:"
		serverLabel.font = UIFont(name: serverLabel.font.fontName, size: 18)
		serverLabel.center = CGPointMake(modeLabel.center.x, self.view.frame.height/2)
		serverLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(serverLabel)
	}
	
	// Creates the segmented control for choosing server type
	func createServerSegmentedControl() {
		serverSegmentedControl = UISegmentedControl.init(items: servers)
		serverSegmentedControl.frame = CGRectMake(serverLabel.frame.maxX, 0, 175, 45)
		serverSegmentedControl.center = CGPointMake(serverSegmentedControl.center.x, serverLabel.center.y)
		
		
		if appDelegate.server.localOrRemoteServer() == "local" {
			serverSegmentedControl.selectedSegmentIndex = 0
		} else {
			serverSegmentedControl.selectedSegmentIndex = 1
		}
		
		serverSegmentedControl.addTarget(self,
		                               action: #selector(LexemeModeViewController.serverModeChanged(_:)),
		                               forControlEvents: UIControlEvents.ValueChanged)
		
		self.view.addSubview(serverSegmentedControl!)
	}
	
	// Responde when the user changes server type
	func serverModeChanged(sender: UISegmentedControl) {
		if serverSegmentedControl.selectedSegmentIndex == 0 {
			appDelegate.server.switchToLocalServer()
		} else {
			appDelegate.server.switchToRemoteServer()
		}
	}

	// Load the settings page
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createLexemeMode()
		self.createModeSegmentedControl()
		self.createServerMode()
		self.createServerSegmentedControl()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
