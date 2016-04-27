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
	
	func sendViewRequest() {
		let requestURL = NSURL(string: serverURL + "view-sentences/")
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
		let requestURL = NSURL(string: serverURL + "start-sentence/")
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
		let responseString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
		print(responseString)
		
//		let dict = self.convertStringToDictionary(responseString)
//		let dict = self.getDictionaryFromData(data)
//		print(dict)
	}
	
	
	func parseResponseMessage(response: String) {
		var parsedLexemes = [ [String: String] ]()
	}
	
	
	
	func convertStringToDictionary(text: String) -> [String:AnyObject]? {
		if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
			do {
				return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
			} catch let error as NSError {
				print(error)
			}
		}
		return nil
	}
	
}