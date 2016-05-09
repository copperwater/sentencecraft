//
//  ViewLexemesTableViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/11/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

// This is a View and Controller since it is used by the User by manipulating the
// ServerRequest model while also showing the View for the User to interact with

class ViewLexemesTableViewController: UITableViewController, UISearchBarDelegate, UITextFieldDelegate {
	
	// Search bar that allows for search by tag
	var searchBar: UISearchBar = UISearchBar()
	
	// Collections to hold the data for the lexemes
	var lexemesDictionary: [[String:AnyObject]] = []
	var lexemesArray: [String] = []
	var tagsArray: [String] = []
	var selectedLexeme: String = String()
	var selectedTags: String = String()
	
	// Global variable
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	// Setup the the table view to display lexemes in a list manner
	func setupTableView() {
		self.tableView = UITableView.init(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.tableFooterView = UIView()
		self.tableView.rowHeight = self.view.frame.height/10
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LexemeCell")
	}
	
	// Setup the search bar to work on the current page
	func setupSearchBar() {
		searchBar.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/10)
		searchBar.showsScopeBar = true
		searchBar.delegate = self
		searchBar.autocapitalizationType = UITextAutocapitalizationType.None
		self.view.addSubview(searchBar)
	}
	
	// Whem the user has clicked the search button to find a tag,
	// request from the server all the lexemes with the requested tag
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		lexemesArray.removeAll()
		tagsArray.removeAll()
		lexemesDictionary.removeAll()
		
		lexemesDictionary = appDelegate.server.sendViewRequest(appDelegate.sentence_or_word_lexeme,
		                                                       tags: searchBar.text!)!
		self.getLexemeStrings()
		self.tableView.reloadData()
	}
	
	// Change the contents of the table based on contents of the searchbar
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		lexemesArray.removeAll()
		tagsArray.removeAll()
		lexemesDictionary.removeAll()
			
		lexemesDictionary = appDelegate.server.sendViewRequest(appDelegate.sentence_or_word_lexeme,
			                                                       tags: searchText)!
		self.getLexemeStrings()
		self.tableView.reloadData()
	}
	
	// Function to print all the lexemes that are currently stored
	func printLexemes() {
		for entry in lexemesDictionary {
			print(entry["lexemes"])
			print("*******")
		}
	}
	
	// Function that reloads the data currently stored in the table
	func reloadData() {
		lexemesArray.removeAll()
		tagsArray.removeAll()
		lexemesDictionary.removeAll()
		
		lexemesDictionary = appDelegate.server.sendViewRequest(appDelegate.sentence_or_word_lexeme,
		                                                       tags: "")!
		
		if lexemesDictionary.count == 0 {
			let alert: UIAlertView = UIAlertView(title: "View Lexemes:", message: "There are no completed lexemes in the server. Consider completing one.", delegate: self, cancelButtonTitle: "Ok")
			alert.show()
		}
		self.getLexemeStrings()
		self.tableView.reloadData()
	}
	
	// Function that gets all the lexemes and tags from the dictionary that is currently stored
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
					if tag != (entry["tags"] as! [String]).last {
						tags += " , "
					}
				}
			}

			lexemesArray.append(lexeme)
			tagsArray.append(tags)
		}
	}
	
	// Displays a message saying no lexemes found based on tag results
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if lexemesDictionary.isEmpty {
			let emptyLabel: UILabel = UILabel(frame: self.tableView.bounds)
			if appDelegate.sentence_or_word_lexeme == "word" {
				emptyLabel.text = "No sentences found"
			} else {
				emptyLabel.text = "No paragraphs found"
			}
			emptyLabel.textAlignment = NSTextAlignment.Center
			emptyLabel.sizeToFit()
			self.tableView.backgroundView = emptyLabel
			self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
			return 0
		}
		self.tableView.backgroundView = nil
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
		return 1
	}
	
	
	// Function that tells the number of rows in the table
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lexemesArray.count
	}
	
	// Function that provides a name for each row in the table
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "LexemeCell")
		cell.textLabel!.text = lexemesArray [indexPath.row]
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
		return cell;
	}
	
	// Function that tells which row the user has clicked on for more details
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedLexeme = self.lexemesArray[indexPath.row]
		selectedTags = self.tagsArray[indexPath.row]
		self.performSegueWithIdentifier("LexemeSegue", sender: self)
	}
	
	// Function that will pass along the information about the lexeme to a view controller
	// with more detials
	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject!) {
		if segue!.identifier == "LexemeSegue" {
			let viewLexemeViewController : ViewLexemeViewController =
							segue!.destinationViewController as! ViewLexemeViewController
			viewLexemeViewController.addData(selectedTags, lexeme: selectedLexeme)
		}
	}
	
	// Load the TableViewController
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
