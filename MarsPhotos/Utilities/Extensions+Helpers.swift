//
//  Extensions.swift
//  MarsPhotos
//
//  Created by Ahmed Osama on 9/15/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import Foundation
import UIKit

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}

class Helpers {
    static func getImageFrom(tabBarSystemItem: UITabBarSystemItem, blueColored: Bool) -> UIImage? {
        let tabBar = UITabBar()
        let item = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: 0)
        tabBar.items = [item]
        if blueColored { // gray otherwise
            tabBar.selectedItem = item
        }
        let itemView = tabBar.subviews[0]
        let imageView = itemView.subviews[0] as? UIImageView
        //let label = itemView.subviews[1] as? UILabel // this is 'item' label
        return imageView?.image
    }
}
