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
	var tagsArray: [String] = []
	
	var server : ServerRequest!
	
	var selectedLexeme: String = String()
	var selectedTags: String = String()

	
	
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
			var tags: String = String()
			let emptyCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
			
			for word in (entry["lexemes"] as! [String]) {
				lexeme += word
				lexeme += " "
			}
			if entry["tags"] == nil {
				tags = ""
			} else {
				for tag in (entry["tags"] as! [String]) {
					if tag.stringByTrimmingCharactersInSet(emptyCharacterSet) == "" {
						continue
					}
					tags += tag
					tags += " , "
				}
			}
//			print(lexeme)
//			print(tags)
			lexemesArray.append(lexeme)
			tagsArray.append(tags)
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
		selectedLexeme = self.lexemesArray[indexPath.row]
		selectedTags = self.tagsArray[indexPath.row]
		self.performSegueWithIdentifier("LexemeSegue", sender: self)
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
		if segue!.identifier == "LexemeSegue" {
			let viewLexemeViewController : ViewLexemeViewController =
							segue!.destinationViewController as! ViewLexemeViewController
			viewLexemeViewController.addData(selectedTags, lexeme: selectedLexeme)
		}
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
