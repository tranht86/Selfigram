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
    
    let image:UIImage
    let user:User
    let comment:String
    
    init(image:UIImage, user:User, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UImage called image and setting it as our
        // image property for Post.
        self.image = image
        self.user = user
        self.comment = comment
    }

}
