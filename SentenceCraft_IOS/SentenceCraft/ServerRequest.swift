//
//  RequestObject.swift
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
			if error != nil
			{
				print("error=\(error)")
				return
			}
			
			// Print out response string
			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print("responseString = \(responseString)")
			
			// Convert server json response to NSDictionary
			do {
				if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
					
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
		task.resume()
	}
	
	func sendStartSentenceRequest(tags: String, sentence: String) {
		let requestURL = NSURL(string: "http://127.0.0.1:5000/start-sentence/")
		let request = NSMutableURLRequest(URL:requestURL!);
		request.HTTPMethod = "POST"
		
		let startJSONObject = [ "sentence_start" : sentence, "tags" : tags]
		do {
			let jsonData = try NSJSONSerialization.dataWithJSONObject(startJSONObject, options: [])
			
			request.HTTPBody = jsonData
			print(request.HTTPBody)
			
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
				data, response, error in
				
				// Check for error
				if error != nil
				{
					print("error=\(error)")
					return
				}
				
				// Print out response string
				let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
				print("responseString = \(responseString)")
				
				// Convert server json response to NSDictionary
				do {
					if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
						
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
			task.resume()


		} catch {
			print("Error -> \(error)")
		}
		
	}
	
	
}