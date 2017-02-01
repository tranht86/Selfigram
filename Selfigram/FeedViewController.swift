//
//  FeedTableViewController.swift
//  Selfigram
//
//  Created by HT on 2017-02-01.
//  Copyright © 2017 HT. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var words = ["Hello", "my", "name", "is", "Selfigram"]
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=089e1bd3e470eb8361c03e32c06fe4be&tags=cat")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            //print("inside dataTaskWithURL with data = \(data!)") //Used to see if datatask is working
            
            //convert Datat to json
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                let json = jsonUnformatted as? [String : AnyObject]
                //print("\(json)") //Used to check if json formatt is retrieved successfully
                
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                //print("\(photosDictionary)") //used to check if we can retrieve photos from JSON response
                
                //let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]]
                //print("\(photosArray)") //checks for value for the key "photo"
                
                if let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] {
                    
                    for photo in photosArray {
                        if let farmID = photo["farm"] as? Int,
                            let serverID = photo["server"] as? String,
                            let photoID = photo["id"] as? String,
                            let secret = photo["secret"] as? String {
                            
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            print(photoURLString)
                            
                            if let photoURL = URL(string: photoURLString) {
                                let me = User(aUsername: "sam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
                                let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
                                self.posts.append(post)
                            }
                        }
                    }
                    
                    // We use OperationQueue.main because we need update all UI elements on the main thread.
                    // This is a rule and you will see this again whenever you are updating UI.
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                
                }
            
            }else{
                print("error with response data")
            }
            
        })
        
        //this is called to start (or restart, if needed) our task
        task.resume()
        
        print("outside dataTaskWithURL")
        
        
        /*let me = User(aUsername: "Henry", aProfileImage: UIImage(named: "Grumpy-Cat")!)
        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")

        posts = [post0, post1, post2, post3, post4]*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) - old W2D2
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        //let post = posts[indexPath.row] - old W2D2
        let post = self.posts[indexPath.row]

        let task = URLSession.shared.downloadTask(with: post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url, let imageData = try? Data(contentsOf: imageURL) {
                OperationQueue.main.addOperation {
                    cell.selfieImageView.image = UIImage(data: imageData)
                }
            }
        //cell.textLabel?.text = "This is a Post" - Example 1
        //cell.textLabel?.text = "This is Post \(indexPath.row)" - Example 2
        //cell.textLabel?.text = words[indexPath.row] - Example 3
        //cell.textLabel?.text = post.comment - Example 4 W2D2
        
        /*cell.selfieImageView.image = post.image
        cell.usernameLabel.text = post.user.username //this set of code is for local data only
        cell.commentLabel.text = post.comment */
        }

        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        print("Camera Button Pressed") //Used to check if button works
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. We create a Post object from the image
            let me = User(aUsername: "sam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
            let post = Post(image: image, user: me, comment: "My Selfie")
            
            //3. Add post to our posts array
            //    Adds it to the very top of our array
            posts.insert(post, at: 0)
            
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismiss(animated: true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
        
    }*/

}
