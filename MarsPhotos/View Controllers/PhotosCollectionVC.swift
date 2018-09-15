//
//  PhotosCollectionVC.swift
//  MarsPhotos
//
//  Created by Ahmed Osama on 9/12/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

private let reuseIdentifier = "FancyCell"

class PhotosCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var rover: String! = "Curiosity"
    var latestResponse: [JSON]?
    var sol = 0
    @IBOutlet weak var actionsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        requestLatestPhotos()
        title = rover
        navigationItem.title = "🛸 Mars Photos"
        actionsButton.image = Helpers.getImageFrom(tabBarSystemItem: .more, blueColored: true)
        addInfoButton()
    }
    
    func addInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func infoButtonTapped() {
        performSegue(withIdentifier: "showInfo", sender: self)
    }
    
    @IBAction func actionsButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Actions", message: "Select an action", preferredStyle: .actionSheet)
        let sol = UIAlertAction(title: "Go To Sol", style: .default) { (action) in
            let solAlert = UIAlertController(title: "Go To Sol", message: "Enter sol number", preferredStyle: .alert)
            solAlert.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = .numberPad
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let value = Int((solAlert.textFields?[0].text)!) {
                    self.requestPhotosOn(sol: value)
                }
            })
            solAlert.addAction(ok)
            self.present(solAlert, animated: true, completion: nil)
        }
        let date = UIAlertAction(title: "Go To Date", style: .default) { (action) in
            let dateAlert = UIAlertController(title: "Go To Date", message: "Format: yyyy-MM-dd", preferredStyle: .alert)
            dateAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "2002-11-26"
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let text = dateAlert.textFields?[0].text, let value = formatter.date(from: text) {
                    self.requestPhotosOn(date: value)
                }
            })
            dateAlert.addAction(ok)
            self.present(dateAlert, animated: true, completion: nil)
        }
        let latest = UIAlertAction(title: "Get Latest Photos", style: .default) { (action) in
            self.requestLatestPhotos()
        }
        let about = UIAlertAction(title: "About Rover", style: .default) { (action) in
            if APIManager.manifest[self.rover] != nil {
                self.showAboutAlert()
            }
            else {
                APIManager.requestManifest(rover: self.rover, completion: {
                    self.showAboutAlert()
                })
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(sol)
        alert.addAction(date)
        alert.addAction(latest)
        alert.addAction(about)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showAboutAlert() {
        let aboutAlert = UIAlertController(title: "About Rover", message: self.getInfo(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        aboutAlert.addAction(ok)
        self.present(aboutAlert, animated: true, completion: nil)
    }
    
    func getInfo() -> String {
        let landingDate = APIManager.manifest[self.rover]!["landing_date"].stringValue
        let launchDate = APIManager.manifest[self.rover]!["launch_date"].stringValue
        let status = APIManager.manifest[self.rover]!["status"].stringValue
        let maxSol = APIManager.manifest[self.rover]!["max_sol"].stringValue
        let maxDate = APIManager.manifest[self.rover]!["max_date"].stringValue
        let totalPhotos = APIManager.manifest[self.rover]!["total_photos"].stringValue
        
        let part1 = "Name: \(rover!)\nLaunch Date: \(launchDate)\nLanding Date: \(landingDate)\n"
        let part2 = "Max Sol: \(maxSol)\nMax Date: \(maxDate)\nTotal Photos: \(totalPhotos)\nStatus: \(status)"
        return part1 + part2
    }
    
    func requestPhotosOn(date: Date) {
        APIManager.requestPhotos(rover: rover, date: date) { (json) in
            self.latestResponse = json.array
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func requestPhotosOn(sol: Int) {
        APIManager.requestPhotos(rover: rover, sol: sol) { (json) in
            self.latestResponse = json.array
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func requestLatestPhotos() {
        APIManager.requestLatestPhotos(rover: rover) { (json) in
            self.latestResponse = json.array
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sol = latestResponse?.count { //rover.totalPhotosOnSol?[sol]
            return sol
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewFancyCell
        
        if var source = latestResponse?[indexPath.row]["img_src"].string {
            source.insert("s", at: source.index(source.startIndex, offsetBy: 4)) //make it https
            let url = URL(string: source)
            cell.imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                if image != nil {
                    cell.contentView.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewFancyCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
        vc.image = cell.imageView.image
        vc.info = latestResponse?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (UIScreen.main.bounds.width - 2 * 2) / 3
        return CGSize(width: value, height: value);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }

}
