//
//  SingleShowViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 10/6/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class SingleShowViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var statusPickerView: UIPickerView!
    
    let statusOptions = ["remove"] + sectionHeaders
    let defaults = UserDefaults.standard
    var show: Show = Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = show.name
        posterImage.image = show.image
//        infoLabel.text = show?.info
        statusPickerView.selectRow(statusOptions.firstIndex(of: show.schedual?.status ?? "") ?? 0, inComponent: 0, animated: false)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return statusOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var savedShows = getShows()
        print("original:", savedShows)
        let currStatus = show.schedual?.status
        //        print(currStatus)
        let currStatusIndex = statusOptions.firstIndex(of: currStatus ?? "") ?? 0
        if currStatusIndex != row
        {
            print("need to change something, \(currStatusIndex), \(row)")
            if row <= 0
            {
                show.schedual = nil
                savedShows = removeShow(with: show.name, shows: savedShows)
            }
            else
            {
                
                if currStatusIndex > 0
                {
                    show.schedual?.status = statusOptions[row]
                    savedShows = moveShow(with: show.name, to: row-1, shows: savedShows)
                    print("new moved: ", savedShows)
                }
                else
                {
                    show.addSchedual(_schedual: Schedual(_status: statusOptions[row]))
                    savedShows[row-1].append(show)
                    print("new added: ", savedShows)
                }
            }
        }
        saveShows(showArr: savedShows)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
