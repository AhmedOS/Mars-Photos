//
//  APIManager.swift
//  MarsPhotos
//
//  Created by Ahmed Osama on 9/12/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    private init() {}
    
    static var manifest = [String: JSON]()
    
    static func setup() {
        for rover in API.rovers {
            requestManifest(rover: rover, completion: nil)
        }
    }
    
    static func requestManifest(rover: String, completion: (() -> ())?) {
        let url = API.manifestURL(rover: rover)
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                manifest[rover] = JSON(json)["photo_manifest"] //["photos"].array
                completion?()
            }
        }
    }
    
    static func requestLatestPhotos(rover: String, completion: ((JSON) -> ())?) {
        let url = API.latestPhotosURL(rover: rover)
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                completion?(JSON(json)["latest_photos"])
            }
        }
    }
    
    static func requestPhotos(rover: String, sol: Int, completion: ((JSON) -> ())?) {
        let url = API.photosURL(rover: rover, sol: String(sol))
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                completion?(JSON(json)["photos"])
            }
        }
    }
    
    static func requestPhotos(rover: String, date: Date, completion: ((JSON) -> ())?) {
        let url = API.photosURL(rover: rover, date: date)
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                completion?(JSON(json)["photos"])
            }
        }
    }
    
}
