//
//  DetailViewController.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 05/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import Foundation
import UIKit

public class DetailViewController: UIViewController {
    
    //Public variable for passing the selected FlickrPhoto
    public var selectedPhoto : FlickrPhoto?
    
    //UILabel outlet for showing the photo title
    @IBOutlet weak var photoTitle: UILabel!
    
    //UIImageView outlet for displaying the image in the FlickrPhoto
    @IBOutlet weak var imageView: UIImageView!
    
    //Instance of AppConstants
    let appConstants : AppConstants = AppConstants()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set the title of the screen
        self.title = appConstants.detailTitle
        
        //Set the imageView image
        self.imageView.image = selectedPhoto!.image
        
        //Set the title for the photo
        self.photoTitle.text = appConstants.photoTitlePrefix + (selectedPhoto?.title)!
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
}