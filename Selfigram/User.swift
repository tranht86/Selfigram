//
//  User.swift
//  Selfigram
//
//  Created by HT on 2017-02-01.
//  Copyright © 2017 HT. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    let username:String
    let profileImage:UIImage
    init(aUsername:String, aProfileImage:UIImage){
        //we are setting the User property of "username" to an aUsername property you are going to pass in
        username = aUsername
        profileImage = aProfileImage

    }
}
