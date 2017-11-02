//
//  Tweet.swift
//  Smashtag
//
//  Created by ChenshuoYue on 6/8/17.
//  Copyright © 2017 Machinarist. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Tweet: NSManagedObject
{
	class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet,
	                             in context: NSManagedObjectContext) throws
		-> Tweet
	{
		let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
		request.predicate = NSPredicate(format: "unique= %@",
		                                twitterInfo.identifier)
		do {
			let matches = try context.fetch(request)
			if matches.count > 0 {
				assert(matches.count == 1,
				       "Tweet.findOrCreateTweet -- database inconsistency")
				return matches[0]
			}
		} catch {
			throw error
		}
		
		// not found, create tweet
		let tweet = Tweet(context: context)
		tweet.unique = twitterInfo.identifier
		tweet.text = twitterInfo.text
		tweet.created = twitterInfo.created as NSDate
		tweet.tweeter =
			 try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user,
			                                    in: context)
		return tweet
		
		
	}
	
	
}
