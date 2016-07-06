//
//  ViewController.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 04/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import UIKit
import FlickrKit

//UIImageView extension to save the image title so that the title is available when FlickrPhoto is tapped in the scrollview
private var titleAssocKey = 0

extension UIImageView {
	// image title
	var imageTitle: String? {
		get {
			return objc_getAssociatedObject(self, &titleAssocKey) as? String
		}
		set {
			objc_setAssociatedObject(self, &titleAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
}

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, FetchFlickrPhotoDelegate {

	// UILabel Outlet for displaying the tag for the currently showing pictures
	@IBOutlet weak var nowShowingLabel: UILabel!

	// UILabel Outlet for showing status of the pictures as loading
	@IBOutlet weak var activityLabel: UILabel!

	// UIScrollView Outlet for showing the images in a scrollview
	@IBOutlet weak var photoScrollView: UIScrollView!

	// AppConstants instance
	let appConstants: AppConstants = AppConstants()

	// UITextField Outlet for taking user input for searching the pictures
	@IBOutlet weak var searchPictures: UITextField!

	// The page number for the Flickr image search
	// Each time the scrollview is scrolled, this value is increased to get the next set of images
	var page: Int = 0

	// The text entered by the user for searching pictures
	var searchText: String? = String()

	// The FlickrPhoto that was tapped
	var tappedPhoto: FlickrPhoto? = FlickrPhoto()

	override func viewDidLoad() {

		super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set the view title
		self.title = appConstants.appTitle
        
        //Set the scrollview as hidden initially
		self.photoScrollView.hidden = true
        
        //Set the activity label as unhidden initially
		self.activityLabel.hidden = false
        
        //Set the scrollview and textfield delegate as self to receive callbacks
		self.photoScrollView.delegate = self
		self.searchPictures.delegate = self
        
		//Initialize FlickrKit with the predefined API key and secret
		FlickrKit.sharedFlickrKit().initializeWithAPIKey(appConstants.apiKey, sharedSecret: appConstants.secret)
        
        //Do first time launch setup
        let firstTimeSetup : InitialSetup = InitialSetup()
        firstTimeSetup.setup()
        
        //Initial page to be fetched in the beginning
        page = 1
        
        //Get the last search text
        searchText = NSUserDefaults.standardUserDefaults().valueForKey(appConstants.lastSearchText) as? String
        
        //If there was no previous search
        //start by showing Today's interesting pictures
        if (searchText == appConstants.kEmpty)
        {
            showInteresting()
        }
        //Else use the last search for fetching the pictures
        else
        {
            //Update the labels on the screen to show the current search
            searchPictures.text = searchText
            self.nowShowingLabel.text = appConstants.nowShowingText + searchText!
            
            //Show the searched pictures
            showSearchedPictures(searchText!)
        }
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
	// MARK: Get interesting pictures as a default search

	func showInteresting() {
        
        //Update the label on screen to show Today's interesting pictures
		self.nowShowingLabel.text = appConstants.todaysInteresting
        
        //Get the Today's interesting pictures using FKFlickrInterestingnessGetList with the required parameters
		let flickrInteresting = FKFlickrInterestingnessGetList()
        
        //The per_page parameter dictates how many pictures would be fetched per page
		flickrInteresting.per_page = appConstants.picturesPerPage
        
        //The page paramter dictates which page of the search would be fetched next
		flickrInteresting.page = String(page)
        
        //Fetch the FlickrPhotos
        let fetchFlickrPhoto : FetchFlickrPhoto = FetchFlickrPhoto()
        fetchFlickrPhoto.fetchFlickrPhotoDelegate = self
        fetchFlickrPhoto.fetchFlickrPhotos(flickrInteresting)

	}

    // MARK: Callback method for FetchFlickrPhoto
    
	func addFlickrPhotoOnScreen(flickrPhoto: FlickrPhoto) {
        
        //Unhide the scrollview and hide the activity label
		self.photoScrollView.hidden = false
		self.activityLabel.hidden = true
        
        //Create an imageView with the FlickrPhoto object's image
		let imageView: UIImageView = UIImageView(image: flickrPhoto.image)
		let width = CGRectGetWidth(self.photoScrollView.frame)
		let imageRatio = flickrPhoto.image!.size.width / flickrPhoto.image!.size.height
		let height = width / imageRatio
		let x: CGFloat = 0
		let subViews = self.photoScrollView.subviews
		var y: CGFloat = 0

        //Reset the y co-ordinate if the photos were removed as a result of a search
		if !subViews .isEmpty
		{
			y = self.photoScrollView.contentSize.height
		}
		imageView.frame = CGRectMake(x, y, width, height)
        
        //Reset the scrollview height if the photos were removed as a result of a search
		var newHeight: CGFloat = 0.0
		if !subViews .isEmpty
		{
			newHeight = self.photoScrollView.contentSize.height + height
		}
		else
		{
			newHeight = 0.0
		}
        
        //Add the tapgesture recognizer for enabling taps on the UIImageView
        //handleTap method would be called on tapping on an image
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
		imageView.userInteractionEnabled = true
		imageView.addGestureRecognizer(tapGestureRecognizer)
        
        //Add the title for the UIImageView
		imageView.imageTitle = flickrPhoto.title
        
        //Add the imageview to the scrollview
		self.photoScrollView.contentSize = CGSizeMake(320, newHeight)
		self.photoScrollView.addSubview(imageView)
	}

    // MARK: Internal method for removing previous images from scrollview when a search is performed
    
	func removeImagesFromScrollView() {
		let subViews = self.photoScrollView.subviews
		for subview in subViews {
			subview.removeFromSuperview()
		}
		self.photoScrollView.hidden = true
		self.activityLabel.hidden = false
	}

    // MARK: UITextField delegate methods
    
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		// Dont clear the images if there is no internet connection
		if (!FKDUReachability.isOffline())
		{
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.removeImagesFromScrollView()
			})
		}
        
        //Save the search term in user defaults
        NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: appConstants.lastSearchText)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //Update the now showing label
		self.nowShowingLabel.text = appConstants.nowShowingText + textField.text!
		searchText = textField.text
        
        //Set the initial page number for the search
		page = 1
		textField.resignFirstResponder()
        
        //Show the searched pictures
        showSearchedPictures(textField.text!)

		return true
	}

    // MARK: Internal method for handling the tap gesture on the image

	func handleTap(sender: UITapGestureRecognizer) {
        //Set the tappedPhoto to the correct image and title
		if sender.state == .Ended {
			let tappedImageView: UIImageView = sender.view as! UIImageView
			tappedPhoto!.image = tappedImageView.image!
			tappedPhoto!.title = tappedImageView.imageTitle
			self.performSegueWithIdentifier("showDetail", sender: self)
		}
	}

    // MARK: Method for preparing for performing segue for navigating to the detail view controller
    
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if segue.identifier == "showDetail" {
			// pass FlickrPhoto to next view
			let destinationVC = (segue.destinationViewController as? DetailViewController)!
			destinationVC.selectedPhoto = tappedPhoto
		}
	}

    // MARK: UIScrollView delegate method
    
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		page = page + 1
        //Check the search text
        //And fetch the next set of Photos
		if (searchText == appConstants.kEmpty)
		{
			showInteresting()
		}
		else
		{
            showSearchedPictures(searchText!)
		}
	}
    
    // MARK: Internal method for searching the pictures by the search string
    
    func showSearchedPictures(searchText : String)
    {
        //Initialize FKFlickrPhotosSearch
        let flickrSearch = FKFlickrPhotosSearch()
        
        //Add the search text
        flickrSearch.text = searchText
        
        //The per_page parameter dictates how many pictures would be fetched per page
        flickrSearch.per_page = appConstants.picturesPerPage
        
        //The page parameter dictates how the page number to be fetched
        flickrSearch.page = String(page)
        
        //Fetch the photos
        let fetchFlickrPhoto : FetchFlickrPhoto = FetchFlickrPhoto()
        
        //Set the delegate to receive the callback
        fetchFlickrPhoto.fetchFlickrPhotoDelegate = self
        
        //Call the fetchFlickrPhotos method
        fetchFlickrPhoto.fetchFlickrPhotos(flickrSearch)
    }
}

