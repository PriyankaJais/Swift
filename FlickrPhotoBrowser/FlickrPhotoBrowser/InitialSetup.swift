//
//  InitialSetup.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 06/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import Foundation

class InitialSetup: NSObject {

    //MARK: Method for performing first time setup, setting up the search text as an empty string
	func setup() {
        
		let constants: AppConstants = AppConstants()
        
        //If this is a first time launch
		if !NSUserDefaults.standardUserDefaults().boolForKey(constants.firstTimeLaunch)
		{
            //Set up the search text as an empty string
			NSUserDefaults.standardUserDefaults().setValue(constants.kEmpty, forKey: constants.lastSearchText)
            
            //Set up first time launch as false
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: constants.firstTimeLaunch)
            
            //Sync the defaults
			NSUserDefaults.standardUserDefaults().synchronize()
		}
	}
}
