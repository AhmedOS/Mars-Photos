//
//  ImageVC.swift
//  MarsPhotos
//
//  Created by Ahmed Osama on 9/13/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import UIKit
import SwiftyJSON

class ImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionsButton: UIBarButtonItem!
    
    var image: UIImage!
    var info: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionsButton.title = ""
        actionsButton.image = Helpers.getImageFrom(tabBarSystemItem: .more, blueColored: true)
        imageView.image = image
    }
    
    @IBAction func actionsButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Actions", message: "Select an action", preferredStyle: .actionSheet)
        let save = UIAlertAction(title: "Save or Share", style: .default) { (action) in
            let vc = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
            self.present(vc, animated: true, completion: nil)
        }
        let about = UIAlertAction(title: "About Photo", style: .default) { (action) in
            let sol = self.info["sol"].stringValue
            let camera = self.info["camera"]["full_name"].stringValue
            let date = self.info["earth_date"].stringValue
            let message = "Sol: \(sol)\nEarth Date: \(date)\nCamera: \(camera)"
            let aboutAlert = UIAlertController(title: "About Photo", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            aboutAlert.addAction(ok)
            self.present(aboutAlert, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(about)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}
