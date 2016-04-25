//
//  ServerRequest.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/22/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import Foundation

class ServerRequest {

	init() {}
	
	func sendViewRequest() {
		let requestURL = NSURL(string: "http://127.0.0.1:5000/view-sentences/")
		let request = NSMutableURLRequest(URL:requestURL!);
		request.HTTPMethod = "GET"
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
			
			self.handleRequestResponse(data!, response: response!)

		}
		task.resume()
	}
	
	func sendStartSentenceRequest(tags: String, sentence: String) {
		let requestURL = NSURL(string: "http://127.0.0.1:5000/start-sentence/")
		let request = NSMutableURLRequest(URL:requestURL!);
		request.HTTPMethod = "POST"
		
		let postString: String = "tags=\(tags)&sentence_start=\(sentence)"
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
			}
			task.resume()
			
	}
	
	
	func handleRequestResponse(data: NSData, response: NSURLResponse) {
		// Print out response string
		let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
		print("responseString = \(responseString)")
		
		// Convert server json response to NSDictionary
		do {
			if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
				
				// Print out dictionary
				print(convertedJsonIntoDict)
				
				// Get value by key
				let firstNameValue = convertedJsonIntoDict["userName"] as? String
				print(firstNameValue!)
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	
}