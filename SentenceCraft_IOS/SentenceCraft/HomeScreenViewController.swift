//
//  HomeScreenViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/7/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
	
	// Buttons that user interacts with on the Home screen
	@IBOutlet private var startLexemeButton: UIButton!
	@IBOutlet private var continueLexemeButton: UIButton!
	@IBOutlet private var viewLexemesButton: UIButton!
	@IBOutlet private var settingButton: UIButton!

	// Instance of the AppDelegate in order to access
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	private var hasViewed: Bool = false
	
	// Create the SentenceCraft Logo on Home Screen 
	func addSentenceCraftLabel() {
		let sentenceCraftLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 500, 200))
		sentenceCraftLabel.text = "SentenceCraft"
		sentenceCraftLabel.font = UIFont(name: sentenceCraftLabel.font.fontName, size: 50)
		sentenceCraftLabel.center = CGPointMake(self.view.center.x, self.view.center.y/3)
		sentenceCraftLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(sentenceCraftLabel)
	}
	
	// Create the button that will let users start a lexeme
	func createStartLexemeButton() {
		startLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		startLexemeButton.setTitle("Start a Lexeme", forState: UIControlState.Normal)
		startLexemeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		startLexemeButton.titleLabel!.font = UIFont(name: startLexemeButton.titleLabel!.font!.fontName,
		                                            size: 25)
		startLexemeButton.frame = CGRectMake(0, 0, 200, 50)
		startLexemeButton.center = CGPointMake(self.view.center.x, 3 * self.view.center.y/5)
		startLexemeButton.layer.cornerRadius = 10
		startLexemeButton.layer.borderWidth = 5
		startLexemeButton.layer.borderColor = UIColor.blueColor().CGColor
		startLexemeButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.startLexemeButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(startLexemeButton)
	}
	
	// Create the button that will let users continue/complete a lexeme
	func createContinueLexemeButton() {
		continueLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		continueLexemeButton.setTitle("Continue a Lexeme", forState: UIControlState.Normal)
		continueLexemeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		continueLexemeButton.titleLabel!.font =
											UIFont(name: continueLexemeButton.titleLabel!.font!.fontName,
											       size: 25)
		continueLexemeButton.frame = CGRectMake(0, 0, 300, 50)
		continueLexemeButton.center = CGPointMake(self.view.center.x, 5 * self.view.center.y/5)
		continueLexemeButton.layer.cornerRadius = 10
		continueLexemeButton.layer.borderWidth = 5
		continueLexemeButton.layer.borderColor = UIColor.blueColor().CGColor
		continueLexemeButton.addTarget(self,
		                               action: #selector(HomeScreenViewController.continueLexemeButtonPressed(_:)),
		                               forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(continueLexemeButton)
	}
	
	// Create the button that will let users view all completed lexemes
	func createViewLexemeButton() {
		viewLexemesButton = UIButton.init(type: UIButtonType.RoundedRect)
		viewLexemesButton.setTitle("View Completed Lexemes", forState: UIControlState.Normal)
		viewLexemesButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		viewLexemesButton.titleLabel!.font = UIFont(name: viewLexemesButton.titleLabel!.font!.fontName,
		                                            size: 25)
		viewLexemesButton.frame = CGRectMake(0, 0, 350, 50)
		viewLexemesButton.center = CGPointMake(self.view.center.x, 7 * self.view.center.y/5)
		viewLexemesButton.layer.cornerRadius = 10
		viewLexemesButton.layer.borderWidth = 5
		viewLexemesButton.layer.borderColor = UIColor.blueColor().CGColor
		viewLexemesButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.viewLexemeButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(viewLexemesButton)
	}
	
	// Create the button that will lead users to edit the settings for the app settings
	func createSettingButton() {
		settingButton = UIButton.init(type: UIButtonType.RoundedRect)
		settingButton.setTitle("Settings", forState: UIControlState.Normal)
		settingButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		settingButton.titleLabel!.font = UIFont(name: settingButton.titleLabel!.font!.fontName,
		                                            size: 25)
		settingButton.frame = CGRectMake(0, 0, 200, 50)
		settingButton.center = CGPointMake(self.view.center.x, 9 * self.view.center.y/5)
		settingButton.layer.cornerRadius = 10
		settingButton.layer.borderWidth = 5
		settingButton.layer.borderColor = UIColor.blueColor().CGColor
		settingButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.settingButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(settingButton)
	}
	
	
	// Action that will move user from home screen to the start lexeme page
	// when the button is pressed
	func startLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("StartLexemeSegue", sender: self)
	}
	
	// Action that will move user from home screen to the coninue/complete lexeme page
	// when the button is pressed
	func continueLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("ContinueLexemeSegue", sender: self)
	}
	
	// Action that will move user from home screen to the view lexemes table page
	// when the button is pressed
	func viewLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("ViewLexemesSegue", sender: self)
	}
	
	// Action that will move the user from the home screen to the settings page
	// when the button is pressed
	func settingButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("SettingSegue", sender: self)
	}
	
	// Actions that will happen in between when a user selects to go a new page
	// and when the next page loads
	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
		if segue!.identifier == "ViewLexemesSegue" {
			let viewLexemesTableViewController : ViewLexemesTableViewController =
				segue!.destinationViewController as! ViewLexemesTableViewController
			viewLexemesTableViewController.reloadData()
		}
	}
	
	// Load the view of the HomeScreenViewController
	override func viewDidLoad() {
		super.viewDidLoad()
		self.addSentenceCraftLabel()
		self.createStartLexemeButton()
		self.createContinueLexemeButton()
		self.createViewLexemeButton()
		self.createSettingButton()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

