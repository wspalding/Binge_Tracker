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
    let headerID = "sectionHeader"
    let sectionHeaders = ["watching","backlog","completed","dropped"]
    
    let defaults = UserDefaults.standard
    var showsArr: [[Show]] {
        print("getting shows array")
        if let savedShows = defaults.object(forKey: showKey) as? Data
        {
            if let decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [[Show]]
            {
                return decodedShows
            }
        }
        print("none found")
        return [[],[],[],[]]
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
//        TODO: section is the var im looking for
        return showsArr[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return showsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionViewCell
//        indexPath.section is the var for the section
        
        cell.showTitleLabel.text = showsArr[indexPath.section][indexPath.item].name
        cell.showImageView.image = showsArr[indexPath.section][indexPath.item].image
        cell.statusLabel.text = showsArr[indexPath.section][indexPath.item].schedual?.status ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! SectionCollectionReusableView
        
        sectionHeaderView.sectionLabel.text = sectionHeaders[indexPath.section]
        
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selected = showsArr[indexPath.section][indexPath.item]
        performSegue(withIdentifier: "show2", sender: self)
    }
}

