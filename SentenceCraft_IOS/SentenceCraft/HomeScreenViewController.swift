//
//  HomeScreenViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/7/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
	
	@IBOutlet private var startLexemeButton: UIButton!
	@IBOutlet private var continueLexemeButton: UIButton!
	@IBOutlet private var viewLexemesButton: UIButton!
	var server : ServerRequest!
	
	func addSentenceCraftLabel() {
		let sentenceCraftLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 500, 200))
		sentenceCraftLabel.text = "SentenceCraft"
		sentenceCraftLabel.font = UIFont(name: sentenceCraftLabel.font.fontName, size: 50)
		sentenceCraftLabel.center = CGPointMake(self.view.center.x, self.view.center.y/3)
		sentenceCraftLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(sentenceCraftLabel)
	}
	
	func createStartLexemeButton() {
		startLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		startLexemeButton.setTitle("Start a Lexeme", forState: UIControlState.Normal)
		startLexemeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		startLexemeButton.titleLabel!.font = UIFont(name: startLexemeButton.titleLabel!.font!.fontName,
		                                            size: 25)
		startLexemeButton.frame = CGRectMake(0, 0, 200, 50)
		startLexemeButton.center = CGPointMake(self.view.center.x, 4 * self.view.center.y/5)
		startLexemeButton.layer.cornerRadius = 10
		startLexemeButton.layer.borderWidth = 5
		startLexemeButton.layer.borderColor = UIColor.blueColor().CGColor
		startLexemeButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.startLexemeButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(startLexemeButton)
	}
	
	func createContinueLexemeButton() {
		continueLexemeButton = UIButton.init(type: UIButtonType.RoundedRect)
		continueLexemeButton.setTitle("Continue a Lexeme", forState: UIControlState.Normal)
		continueLexemeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		continueLexemeButton.titleLabel!.font =
											UIFont(name: continueLexemeButton.titleLabel!.font!.fontName,
											       size: 25)
		continueLexemeButton.frame = CGRectMake(0, 0, 300, 50)
		continueLexemeButton.center = CGPointMake(self.view.center.x, 6 * self.view.center.y/5)
		continueLexemeButton.layer.cornerRadius = 10
		continueLexemeButton.layer.borderWidth = 5
		continueLexemeButton.layer.borderColor = UIColor.blueColor().CGColor
		continueLexemeButton.addTarget(self,
		                               action: #selector(HomeScreenViewController.continueLexemeButtonPressed(_:)),
		                               forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(continueLexemeButton)
	}
	
	func createViewLexemeButton() {
		viewLexemesButton = UIButton.init(type: UIButtonType.RoundedRect)
		viewLexemesButton.setTitle("View Completed Lexemes", forState: UIControlState.Normal)
		viewLexemesButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		viewLexemesButton.titleLabel!.font = UIFont(name: viewLexemesButton.titleLabel!.font!.fontName,
		                                            size: 25)
		viewLexemesButton.frame = CGRectMake(0, 0, 350, 50)
		viewLexemesButton.center = CGPointMake(self.view.center.x, 8 * self.view.center.y/5)
		viewLexemesButton.layer.cornerRadius = 10
		viewLexemesButton.layer.borderWidth = 5
		viewLexemesButton.layer.borderColor = UIColor.blueColor().CGColor
		viewLexemesButton.addTarget(self,
		                            action: #selector(HomeScreenViewController.viewLexemeButtonPressed(_:)),
		                            forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(viewLexemesButton)
	}
	
	
	func startLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("StartLexemeSegue", sender: self)
	}
	
	func continueLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("ContinueLexemeSegue", sender: self)
	}
	
	func viewLexemeButtonPressed(sender: UIButton!) {
		self.performSegueWithIdentifier("ViewLexemesSegue", sender: self)
		server.sendViewRequest()
	}
	
//	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
//		if segue!.identifier == "StartLexemeSegue" {
//			let startLexemeController: StartLexemeViewController =
//				segue!.destinationViewController as! StartLexemeViewController
//		}
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.server = ServerRequest.init()
		self.addSentenceCraftLabel()
		self.createStartLexemeButton()
		self.createContinueLexemeButton()
		self.createViewLexemeButton()
		self.navigationController?.navigationBar.topItem?.title = "Home Screen"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

