//
//  FetchFlickrPhoto.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 06/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import Foundation
import UIKit
import FlickrKit

@objc public protocol FetchFlickrPhotoDelegate: class {

	/*Callback method for updating the screen once the image download is finished
	 *@param flickrPhoto an instance of FlickrPhoto that would be passed back to the calling class
	 */
	func addFlickrPhotoOnScreen(flickrPhoto: FlickrPhoto)
}

public class FetchFlickrPhoto: NSObject {

	// Array of FlickrPhoto Objects
	var flickrPhotos: [FlickrPhoto]!

	// NSOperationQueue for the download of the images
	let downloadQueue: NSOperationQueue = NSOperationQueue()

	// The delegate object for giving callbacks once the download operation is completed
	public var fetchFlickrPhotoDelegate: FetchFlickrPhotoDelegate?

	/* fetchFlickrPhotos method for fetching the flickr photo URL's , performing the download in the background and giving the callbacks to the calling class with the fully created FlickPhoto object
	 * @param apiMethod: FKFlickrAPIMethod the parameter for making the search with the help of FlickrKit
	 */
	public func fetchFlickrPhotos(apiMethod: FKFlickrAPIMethod)
	{
		// Start the network activity indicator
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true

		// Cancel all the previous downloads in the queue
		self.cancelAllDownloads()

		// Empty the array of Flickr photos
		self.flickrPhotos = []

		// Fetch the Flickr photo details on a background queue
		// And process the response
		FlickrKit.sharedFlickrKit().call(apiMethod) { (response, error) -> Void in
            
            //Fetch the global background queue
			let qualityOfServiceClass = QOS_CLASS_BACKGROUND
			let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            
            //Perform the processing on the background queue
			dispatch_async(backgroundQueue, {
				if (response != nil) {

					// Fetch the photo URL's from the response
					let topPhotos = response["photos"] as! [NSObject: AnyObject]
					let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]

					// Get the URL for each element
					for photoDictionary in photoArray {

						// Get the photo URL
						let photoURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)

						// Get the photo title
						let photoTitle: String! = FlickrKit.sharedFlickrKit().photoTitle(photoDictionary)

						// Create a FlickrPhoto object with the URL and title
						let flickrPhoto: FlickrPhoto = FlickrPhoto()
						flickrPhoto.imageURL = photoURL
						flickrPhoto.title = photoTitle

						// Append the FlickrPhoto to the array
						self.flickrPhotos.append(flickrPhoto)
					}

					// Iterate through the FlickrPhoto array
					for flickrPhoto in self.flickrPhotos {

						// Create a block operation for downloading the photo from the URL
						let blockOperation = NSBlockOperation()

						// Add the execution block
						blockOperation.addExecutionBlock({

							// Perform the download only if the operation was not marked as cancelled
							if (!blockOperation.cancelled)
							{
								// Start the Network activity indicator
								dispatch_async(dispatch_get_main_queue(), { () -> Void in
									UIApplication.sharedApplication().networkActivityIndicatorVisible = true
								})

								// Call the method for the download of the photo
								self.startDownloadForPhoto(flickrPhoto)

								// Stop the Network activity indicator
								dispatch_async(dispatch_get_main_queue(), { () -> Void in
									UIApplication.sharedApplication().networkActivityIndicatorVisible = false
								})
							}
						})

						// Add the operation to the operation queue
						self.downloadQueue.addOperation(blockOperation)
					}
				} else {
					// Iterating over specific errors for each service
					switch error.code {
					case FKFlickrInterestingnessGetListError.ServiceCurrentlyUnavailable.rawValue:
						break;
					default:
						break;
					}
				}
			})
		}
	}

    //MARK: Internal method for cancelling all the operations on the queue
    
	func cancelAllDownloads() {
        
        //Cancel all the operations in the queue
		downloadQueue.cancelAllOperations()
	}

    //MARK: Internal method for performing the download of the FlickrPhoto image from the URL
    
	func startDownloadForPhoto(flickrPhoto: FlickrPhoto) {
        
        //Form the request from the image URL
		let request = NSMutableURLRequest(URL: flickrPhoto.imageURL!)
        
        //Create an NSURLSession
		let session = NSURLSession.sharedSession()
        
        //Set the HTTP method
		request.HTTPMethod = "GET"
        
        //Set up the data task
		let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
			if data != nil
			{
                //If the request finished successfully, update the FlickrPhoto object with the image
				let image = UIImage(data: data!)
				flickrPhoto.image = image
                
                //Call the delegate method on the main queue since it updates the UI
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
					self.fetchFlickrPhotoDelegate?.addFlickrPhotoOnScreen(flickrPhoto)
				})
			} })
        
        //Start the task
		task.resume()
	}
}
