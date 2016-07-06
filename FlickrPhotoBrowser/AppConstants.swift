//
//  AppConstants.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 04/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import Foundation
import UIKit
class AppConstants: NSObject {
    
    //Constant for the theme colour of the application
    let themeColor = UIColor(red: 0/255.0, green: 176/255.0, blue: 244/255.0, alpha: 1.0)
    
    //Constant for the API key
    let apiKey: String = "a53c82d4ecf1a29dd178da5f2e6a6d6d"
    
    //Constant for the secret
    let secret: String = "e524c2b43d38fb21"
    
    //Constant for the Title of the list screen
    let appTitle: String = "Flickr Photo Browser"
    
    //Constant for Title of the details screen
    let detailTitle: String = "Photo Details"
    
    //Constant for prefixing with the photo title
    let photoTitlePrefix: String = "Title : "
    
    //Constant for text for today's interesting photos
    let todaysInteresting: String = "Now Showing : Today's Interesting"
    
    //Constant for the pictures per page that need to be fetched
    let picturesPerPage: String = "5"
    
    //Constant for text for showing the tag of the pictures being displayed in the list
    let nowShowingText: String = "Now Showing : "
    
    //Constant for saving the first time launch bool in user defaults
    let firstTimeLaunch: String = "firstTimeLaunch"
    
    //Constant for saving the last search text in user defaults
    let lastSearchText: String = "lastSearchText"
    
    //Constant for empty string
    let kEmpty: String = ""
}
