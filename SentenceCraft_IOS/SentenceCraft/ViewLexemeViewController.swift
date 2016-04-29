//
//  ViewLexemeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class ViewLexemeViewController: UIViewController {
	
	
	private var tagsInfo: UILabel = UILabel()
	private var lexemeText: UILabel = UILabel()
	
	// Function that reads in the data passed and displays it to the user
	func addData(tags: String, lexeme: String) {
		// Displayes the tags
		tagsInfo = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width, 50))
		tagsInfo.text = "Tags: \(tags)"
		tagsInfo.numberOfLines = 0
		tagsInfo.lineBreakMode = NSLineBreakMode.ByWordWrapping
		tagsInfo.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		tagsInfo.center = CGPointMake(tagsInfo.center.x, tagsInfo.frame.width/3)
		tagsInfo.textAlignment = NSTextAlignment.Center
		self.view.addSubview(tagsInfo)

		// Displays the lexeme
		lexemeText = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.width - 40, 400))
		lexemeText.text = "Lexeme: \n\(lexeme)"
		lexemeText.numberOfLines = 0
		lexemeText.lineBreakMode = NSLineBreakMode.ByWordWrapping
		lexemeText.font = UIFont(name: tagsInfo.font.fontName, size: 25)
		lexemeText.center = CGPointMake(lexemeText.center.x, self.view.center.y)
		lexemeText.textAlignment = NSTextAlignment.Center
		self.view.addSubview(lexemeText)

		
	}

	// Load the View Controller
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
