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
    var showsArr: [Show] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test_show = Show(_name: "test", _status: Status.watching, _numberOfEpisodes: 10, _numberOfSeasons: 2, _image: UIImage(named: "iconfinder_create_new_2639799"), _runTime: TimeInterval(22))
        
        // fill showsArr here
        showsArr = [test_show, test_show, test_show, test_show, test_show]
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
        
        return cell
    }
}

