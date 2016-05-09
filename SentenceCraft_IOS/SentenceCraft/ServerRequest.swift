//
//  ServerRequest.swift
//  SentenceCraft
//
//  Created by Tausif Ahmed on 4/22/16.
//  Copyright © 2016 SentenceCraft. All rights reserved.
//

import Foundation

// This is a model in the MVC pattern since it has information that is manipulated by other Controllers
// where different types of information from the Controllers are sent which in turn updates the View that
// the user sees

class ServerRequest {
	
	private var serverURL: String
	private let LOCALSERVER = "http://127.0.0.1:5000/"
	private let REMOTESERVER = "http://128.113.151.26:5000/"

	init() {
		serverURL = LOCALSERVER
	}
	
	func switchToRemoteServer() {
		serverURL = REMOTESERVER
	}
	
	func switchToLocalServer() {
		serverURL = LOCALSERVER
	}
	
	func localOrRemoteServer() -> String {
		if serverURL == LOCALSERVER {
			return "local"
		}
		return "remote"
	}
	
	// Function to send a Start Lexeme request to the server
	func sendStartSentenceRequest(tags: String, sentence: String, type: String) -> String {
		
		var retString: String = String()
		
		// Create the request
		let requestURL = NSURL(string: serverURL + "start/")
		let request = NSMutableURLRequest(URL:requestURL!);

		request.HTTPMethod = "POST"
		
		// Format the info so the server can handle it
		let postString: String = "tags=\(tags)&start=\(sentence)&type=\(type)"
		let postData: NSData = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
		let postLength: String = "\(postData.length)"
		request.setValue(postLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = postData
		
		// Send the task and wait for a response
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			retString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
				
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
		}
		task.resume()
		while(retString.isEmpty) {}
		return retString
	}
	
	// Function to request an incomplete lexeme from the server for the user to complete or continue
	func requestIncompleteLexeme(type: String) -> [String: AnyObject]? {
		// Create the request
		let requestURL = NSURL(string: serverURL + "incomplete/?type=\(type)")
		let request = NSMutableURLRequest(URL: requestURL!)
		request.HTTPMethod = "GET"
		var dict: [String:AnyObject] = [:]
		var isDictionary: Bool = true
		
		// Send the request and wait for a response
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			if error != nil {
				print("error=\(error)")
				return
			}
			
			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
			if responseString[responseString.startIndex] != "{" {
				isDictionary = false
			} else {
			// Convert the response from JSON to a dictionary
				do {
					dict =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
				} catch _ {}
			}
		}
		task.resume()
		while(dict.count < 1) { if isDictionary == false {break} }
		return dict
	}
	
	// Function to send the user input to the server API to continue or complete a sentence
	func sendAppendRequest(appendage: String, key: String, action: String, type: String) -> String {
		
		var retString: String = String()
		
		// Create the request
		let requestURL = NSURL(string: serverURL + "append/")
		let request = NSMutableURLRequest(URL:requestURL!);
		
		request.HTTPMethod = "POST"
		
		// Format the content of the message for the server
		let postString: String = "key=\(key)&addition=\(appendage)&type=\(type)&complete=\(action)"
		let postData: NSData = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
		let postLength: String = "\(postData.length)"
		request.setValue(postLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = postData
		
		// Send the request and wait for a response from the server
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			retString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
			
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
		}
		task.resume()
		while(retString.isEmpty) {}
		return retString
	}
	
	// Function to send a view request to the server
	func sendViewRequest(type: String, tags: String) -> [[String: AnyObject]]? {
		// Create the request
		let urlString = serverURL + "view/?type=\(type)&tags=\(tags)"
		let encodedURL = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
		let requestURL = NSURL(string: encodedURL!)
		let request = NSMutableURLRequest(URL:requestURL!)
		var dict: [[String:AnyObject]] = []
		var isDictionaryList: Bool = true
		request.HTTPMethod = "GET"
		
		// Send the request and wait for a response
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			// Check for error
			if error != nil {
				print("error=\(error)")
				return
			}
			
			// Check the response string to see if it is a list of dictionaries
			let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
			if responseString[responseString.startIndex] != "[" {
				isDictionaryList = false
			} else {
				// If the JSON object is in the right format, convert it into a list of dictionaries
				do {
					dict =
						try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [[String:AnyObject]]
				} catch _ {}
			}

		}
		task.resume()
		// Wait for the dictionary to be populated by the request
		while(dict.count < 1) { if isDictionaryList == false {break} }
		return dict
	}	
}