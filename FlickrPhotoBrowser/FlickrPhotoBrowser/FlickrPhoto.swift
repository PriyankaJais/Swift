//
//  FlickrPhoto.swift
//  FlickrPhotoBrowser
//
//  Created by Priyanka on 06/07/16.
//  Copyright © 2016 capgemini. All rights reserved.
//

import Foundation
import UIKit

//Class for holding attributes of a FlickrPhoto
public class FlickrPhoto: NSObject{
    
    //The image for the FlickrPhoto
    var image: UIImage?
    
    //The title for the FlickrPhoto
    var title: String?
    
    //The image url for the FlickrPhoto
    var imageURL: NSURL?
}