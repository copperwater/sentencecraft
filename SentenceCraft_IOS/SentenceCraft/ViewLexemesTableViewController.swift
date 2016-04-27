//
//  ViewLexemesTableViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class ViewLexemesTableViewController: UITableViewController {
	
	let navBar: UINavigationBar = UINavigationBar.init()
	
	let exampleLexemes: [String] = ["Lexeme 1", "Lexeme 2", "Lexeme 3"]
	
	var lexemesDictionary: [[String:AnyObject]] = []
	
	var lexemesArray: [String] = []
	
	var server : ServerRequest!

	
	
	func setupTableView() {
		self.tableView = UITableView.init(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LexemeCell")
	}
	
	func printLexemes() {
		for entry in lexemesDictionary {
			print(entry["lexemes"])
			print("*******")
		}
	}
	
	func getLexemeStrings() {
		for entry in lexemesDictionary {
			var lexeme: String = String()
			for word in (entry["lexemes"] as! [String]) {
				lexeme += word
				lexeme += " "
			}
			print(lexeme)
			lexemesArray.append(lexeme)
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lexemesArray.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "LexemeCell")
		cell.textLabel!.text = lexemesArray [indexPath.row]
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
		return cell;
	}
	

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("LexemeSegue", sender: self)
//		print(example_lexemes[indexPath.row])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		server = ServerRequest.init()
		lexemesDictionary = server.sendViewRequest()!
		self.getLexemeStrings()
//		self.navigationController?.navigationBar.topItem?.title = "Lexemes"
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
