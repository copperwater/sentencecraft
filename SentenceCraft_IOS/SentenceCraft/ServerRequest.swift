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
	
	func sendStartSentenceRequest(tags: String, sentence: String, type: String) {
		let requestURL = NSURL(string: serverURL + "start/")
		let request = NSMutableURLRequest(URL:requestURL!);

		request.HTTPMethod = "POST"
		
		let postString: String = "tags=\(tags)&start=\(sentence)&type=\(type)"
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
	
	
	func requestIncompleteLexeme(type: String) -> [String: AnyObject]? {
		let requestURL = NSURL(string: serverURL + "incomplete/?type=\(type)")
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
	
	
	func sendAppendRequest(appendage: String, key: String, action: String, type: String) {
		let requestURL = NSURL(string: serverURL + "append/")
		let request = NSMutableURLRequest(URL:requestURL!);
		
		request.HTTPMethod = "POST"
		
		let postString: String = "key=\(key)&addition=\(appendage)&type=\(type)&complete=\(action)"
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
			
			
			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print("response \(responseString)")
			
		}
		task.resume()

	}
	
	
	func sendViewRequest(type: String) -> [[String: AnyObject]]? {
		let requestURL = NSURL(string: serverURL + "view/?type=\(type)&tags=")
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