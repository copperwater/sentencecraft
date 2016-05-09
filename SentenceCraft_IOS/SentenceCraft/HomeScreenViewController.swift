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
	@IBOutlet private var startButton: UIButton!
	@IBOutlet private var continueButton: UIButton!
	@IBOutlet private var viewButton: UIButton!
	@IBOutlet private var settingsButton: UIButton!

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
	func createStartButton() {
		startButton = UIButton.init(type: UIButtonType.RoundedRect)
		startButton.setTitle("Start", forState: UIControlState.Normal)
		startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		startButton.backgroundColor = UIColor(netHex: 0x18bc9c)
		startButton.titleLabel!.font = UIFont(name: startButton.titleLabel!.font!.fontName,
		                                            size: 25)
		startButton.frame = CGRectMake(0, 0, 250, 50)
		startButton.center = CGPointMake(self.view.center.x, 5 * self.view.center.y/7)
		startButton.layer.cornerRadius = 10
		startButton.layer.borderWidth = 5
		startButton.layer.borderColor = startButton.backgroundColor!.CGColor
		startButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.startButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(startButton)
	}
	
	// Create the button that will let users continue/complete a lexeme
	func createContinueButton() {
		continueButton = UIButton.init(type: UIButtonType.RoundedRect)
		continueButton.setTitle("Continue", forState: UIControlState.Normal)
		continueButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		continueButton.backgroundColor = UIColor(netHex: 0x3498db)
		continueButton.titleLabel!.font =
											UIFont(name: continueButton.titleLabel!.font!.fontName,
											       size: 25)
		continueButton.frame = CGRectMake(0, 0, 250, 50)
		continueButton.center = CGPointMake(self.view.center.x, self.view.center.y)
		continueButton.layer.cornerRadius = 10
		continueButton.layer.borderWidth = 5
		continueButton.layer.borderColor = continueButton.backgroundColor!.CGColor
		continueButton.addTarget(self,
		                               action: #selector(HomeScreenViewController.continueButtonPressed(_:)),
		                               forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(continueButton)
	}
	
	// Create the button that will let users view all completed lexemes
	func createViewButton() {
		viewButton = UIButton.init(type: UIButtonType.RoundedRect)
		viewButton.setTitle("View", forState: UIControlState.Normal)
		viewButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		viewButton.backgroundColor = UIColor(netHex: 0xf39c12)
		viewButton.titleLabel!.font = UIFont(name: viewButton.titleLabel!.font!.fontName,
		                                            size: 25)
		viewButton.frame = CGRectMake(0, 0, 250, 50)
		viewButton.center = CGPointMake(self.view.center.x, 9 * self.view.center.y/7)
		viewButton.layer.cornerRadius = 10
		viewButton.layer.borderWidth = 5
		viewButton.layer.borderColor = viewButton.backgroundColor!.CGColor
		viewButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.viewButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(viewButton)
	}
	
	// Create the button that will lead users to edit the settings for the app settings
	func createSettingButton() {
		settingsButton = UIButton.init(type: UIButtonType.RoundedRect)
		settingsButton.setTitle("Settings", forState: UIControlState.Normal)
		settingsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		settingsButton.backgroundColor = UIColor.lightGrayColor()
		settingsButton.titleLabel!.font = UIFont(name: settingsButton.titleLabel!.font!.fontName,
		                                            size: 25)
		settingsButton.frame = CGRectMake(0, 0, 250, 50)
		settingsButton.center = CGPointMake(self.view.center.x, 11 * self.view.center.y/7)
		settingsButton.layer.cornerRadius = 10
		settingsButton.layer.borderWidth = 5
		settingsButton.layer.borderColor = settingsButton.backgroundColor!.CGColor
		settingsButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.settingButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(settingsButton)
	}
	
	
	// Action that will move user from home screen to the start lexeme page
	// when the button is pressed
	func startButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("StartLexemeSegue", sender: self)
	}
	
	// Action that will move user from home screen to the coninue/complete lexeme page
	// when the button is pressed
	func continueButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("ContinueLexemeSegue", sender: self)
	}
	
	// Action that will move user from home screen to the view lexemes table page
	// when the button is pressed
	func viewButtonPressed(sender: UIButton!) {
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
		self.createStartButton()
		self.createContinueButton()
		self.createViewButton()
		self.createSettingButton()
		
		self.navigationController!.navigationBar.titleTextAttributes =
			[NSForegroundColorAttributeName: UIColor.whiteColor()]
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}	
}

