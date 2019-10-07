//
//  ViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/24/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var showViewContrller: UICollectionView!
    var selected: Show?
    
    let defaults = UserDefaults.standard
    var showsArr: [Show] {
        print("getting shows array")
        if let savedShows = defaults.object(forKey: showKey) as? Data
        {
            if let decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [Show]
            {
                return decodedShows
            }
        }
        return []
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        showViewContrller.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showViewContrller.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SingleShowViewController
        vc.show = selected ?? Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return showsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionViewCell
        
        cell.showTitleLabel.text = showsArr[indexPath.item].name
        cell.showImageView.image = showsArr[indexPath.item].image
        cell.statusLabel.text = showsArr[indexPath.item].schedual?.status ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = showsArr[indexPath.item]
        performSegue(withIdentifier: "show2", sender: self)
    }
}

