//
//  LexemeModeViewController.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/28/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import UIKit

class LexemeModeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	
	let modes: [String] = ["Sentence", "Paragraph"]
	
	var modePicker: UIPickerView = UIPickerView()
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	
	func createLexemeMode() {
		let modeLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, 300, 50))
		modeLabel.text = "Lexeme Mode:"
		modeLabel.font = UIFont(name: modeLabel.font.fontName, size: 25)
		modeLabel.center = CGPointMake(modeLabel.center.x, modeLabel.frame.width/2)
		modeLabel.textAlignment = NSTextAlignment.Center
		self.view.addSubview(modeLabel)
	}
	
	func createModePicker() {
		modePicker = UIPickerView(frame: CGRectMake(0, 200, 200, 200))
		modePicker.tag = 2
		modePicker.delegate = self
		modePicker.dataSource = self
		modePicker.showsSelectionIndicator = true
		
		self.view.addSubview(modePicker)
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if (pickerView.tag == 0) {
			return modes.count
		} else {
			return modes.count
		}
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return modes[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		if (pickerView.tag == 0) {
//			print(modes[row])
			appDelegate.sentence_or_word_lexeme = "word"
//			print(appDelegate.sentence_or_word_lexeme)
		} else  {
//			print(modes[row])
			appDelegate.sentence_or_word_lexeme = "sentence"
//			print(appDelegate.sentence_or_word_lexeme)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createLexemeMode()
		self.createModePicker()
		//		self.navigationController?.navigationBar.topItem?.title = "Lexemes"
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
