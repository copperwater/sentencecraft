//
//  ServerRequest.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/22/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import Foundation

class ServerRequest {
	
	private var serverURL: String

	init() {
		serverURL = "http://127.0.0.1:5000/"
	}
	
	func sendStartSentenceRequest(tags: String, sentence: String) {
		let requestURL = NSURL(string: serverURL + "start/")
		let request = NSMutableURLRequest(URL:requestURL!);

		request.HTTPMethod = "POST"
		
		let postString: String = "tags=\(tags)&start=\(sentence)&type=word"
		let postData: NSData = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
		let postLength: String = "\(postData.length)"
		request.setValue(postLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = postData
			
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
				
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
			
//			
//			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//			print("response \(responseString)")
			
		}
		task.resume()
	}
	
	
	func requestIncompleteLexeme() -> [String: AnyObject]? {
		let requestURL = NSURL(string: serverURL + "incomplete/?type=word")
		let request = NSMutableURLRequest(URL: requestURL!)
		request.HTTPMethod = "GET"
		var dict: [String:AnyObject] = [:]
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			if error != nil {
				print("error=\(error)")
				return
			}
			
			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print("response \(responseString)")
			
			dict = self.convertDataToDictionary(data!)!
		}
		task.resume()
		while(dict.count < 1) {}
//		print(dict)
		return dict

	}
	
	
	func sendViewRequest() -> [[String: AnyObject]]? {
		let requestURL = NSURL(string: serverURL + "view/?type=word&tags=")
		let request = NSMutableURLRequest(URL:requestURL!)
		var dict: [[String:AnyObject]] = []
		request.HTTPMethod = "GET"
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
			
			dict = self.convertDataToDictionaryList(data!)!
			
		}
		task.resume()
		while(dict.count < 1) {}
//		print("HOHOHOHO \(dict)")
		return dict
	}
	
	func convertDataToDictionaryList(data: NSData) -> [[String:AnyObject]]? {
		do {
			return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String:AnyObject]]
		} catch let error as NSError {
			print(error)
		}
		
		return nil
	}
	
	func convertDataToDictionary(data: NSData) -> [String:AnyObject]? {
		do {
			return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
		} catch let error as NSError {
			print(error)
		}
		
		return nil
	}
	
}