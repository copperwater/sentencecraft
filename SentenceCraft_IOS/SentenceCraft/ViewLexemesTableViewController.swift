//
//  ViewLexemesTableViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class ViewLexemesTableViewController: UITableViewController, UISearchBarDelegate, UITextFieldDelegate {
	
	let navBar: UINavigationBar = UINavigationBar.init()
	var searchBar: UISearchBar = UISearchBar()
	
	var lexemesDictionary: [[String:AnyObject]] = []
	var lexemesArray: [String] = []
	var tagsArray: [String] = []
	var selectedLexeme: String = String()
	var selectedTags: String = String()
	
	var server : ServerRequest = ServerRequest.init()
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	
	func setupTableView() {
		self.tableView = UITableView.init(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.tableFooterView = UIView()
		self.tableView.rowHeight = self.view.frame.height/10
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LexemeCell")
	}
	
	func setupSearchBar() {
		searchBar.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/10)
		searchBar.showsScopeBar = true
		searchBar.delegate = self
		searchBar.autocapitalizationType = UITextAutocapitalizationType.None
		self.view.addSubview(searchBar)
	}
	
	func searchBarSearchButtonClicked( searchBar: UISearchBar) {
		lexemesArray.removeAll()
		tagsArray.removeAll()
		lexemesDictionary.removeAll()
		
		lexemesDictionary = appDelegate.server.sendViewRequest(appDelegate.sentence_or_word_lexeme,
		                                                       tags: searchBar.text!)!
		self.getLexemeStrings()
		self.tableView.reloadData()
	}
	
	func printLexemes() {
		for entry in lexemesDictionary {
			print(entry["lexemes"])
			print("*******")
		}
	}
	
	func reloadData() {
		lexemesArray.removeAll()
		tagsArray.removeAll()
		lexemesDictionary.removeAll()
		
		lexemesDictionary = appDelegate.server.sendViewRequest(appDelegate.sentence_or_word_lexeme,
		                                                       tags: "")!
		self.getLexemeStrings()
		self.tableView.reloadData()
	}
	
	func getLexemeStrings() {
		
		lexemesArray.append("")
		tagsArray.append("")
		
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
		self.setupSearchBar()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
