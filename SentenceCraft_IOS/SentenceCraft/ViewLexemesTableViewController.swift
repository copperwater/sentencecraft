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
	
	let example_lexemes: [String] = ["Lexeme 1", "Lexeme 2", "Lexeme 3"]
	
	
	func setupTableView() {
		self.tableView = UITableView.init(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LexemeCell")		
	}
	
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return example_lexemes.count
		
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "LexemeCell")
		cell.textLabel!.text = example_lexemes [indexPath.row]
		return cell;
	}
	

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("LexemeSegue", sender: self)
//		print(example_lexemes[indexPath.row])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
//		self.navigationController?.navigationBar.topItem?.title = "Lexemes"
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
