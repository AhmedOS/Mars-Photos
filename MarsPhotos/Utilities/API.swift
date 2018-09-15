//
//  API.swift
//  MarsPhotos
//
//  Created by Ahmed Osama on 9/12/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation

enum API {
    static func latestPhotosURL(rover: String) -> String {
        return API.baseURL + "rovers/" + rover + "/latest_photos" + API.key
    }
    static func photosURL(rover: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return API.baseURL + "rovers/" + rover + "/photos" + API.key + "&earth_date=" + formatter.string(from: date)
    }
    static func photosURL(rover: String, sol: String) -> String {
        return API.baseURL + "rovers/" + rover + "/photos" + API.key + "&sol=" + sol
    }
    static func manifestURL(rover: String) -> String {
        return API.baseURL + "manifests/" + rover + API.key
    }
    static let baseURL = "https://api.nasa.gov/mars-photos/api/v1/"
    static let rovers = ["Curiosity", "Opportunity", "Spirit"]
    static let key = "?api_key=Lk4wHhF9nv1csgMpGjRmY1gmTMAXA3ZcaeSQYngp" //DEMO_KEY
    
    static let cameras = [ "Curiosity" : ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM" ],
                           "Opportunity" : ["FHAZ", "RHAZ", "NAVCAM", "PANCAM", "MINITES"],
                           "Spirit" : ["FHAZ", "RHAZ", "NAVCAM", "PANCAM", "MINITES"] ]
}

