//
//  Post.swift
//  Selfigram
//
//  Created by HT on 2017-02-01.
//  Copyright © 2017 HT. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    //let image:UIImage //previously used to retrieve local images
    let imageURL:URL
    let user:User
    let comment:String
    
    //init(image:UIImage, user:User, comment:String){ //previously used to retrieve local images from UIImage
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UImage called image and setting it as our
        // image property for Post.
    init(imageURL:URL, user:User, comment:String) {
        //self.image = image //previously used to retrieve local images from UIImage
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }

}
