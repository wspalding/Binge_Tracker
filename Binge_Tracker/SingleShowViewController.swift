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
    
    let statusOptions = ["remove", "backlog", "watching", "completed", "dropped"]
    let defaults = UserDefaults.standard
    var show: Show?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = show?.name
        posterImage.image = show?.image
//        infoLabel.text = show?.info
        statusPickerView.selectRow(statusOptions.firstIndex(of: show?.schedual?.status ?? "") ?? 0, inComponent: 0, animated: false)
        
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
        if row != 0
        {
            var found = false
            let stat = statusOptions[row]
//            print(stat)
            if let savedShows = defaults.object(forKey: showKey) as? Data
            {
                if var decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [Show]
                {
                    for s in decodedShows
                    {
                        if s.name == show?.name
                        {
                            found = true
                            s.addSchedual(_schedual: Schedual(_status: stat))
                        }
                    }
                    if !found
                    {
                        show?.addSchedual(_schedual: Schedual(_status: stat))
                        decodedShows.append(show!)
                    }
                    saveShows(decodedShows)
                }
            }
            else
            {
                show!.addSchedual(_schedual: Schedual(_status: stat))
                saveShows([show!])
            }
        }
        else
        {
//            print("removing")
            if let savedShows = defaults.object(forKey: showKey) as? Data
            {
                if var decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [Show]
                {
                    for s in decodedShows
                    {
                        if s.name == show?.name
                        {
                            decodedShows.remove(at: decodedShows.firstIndex(of: s)!)
                            break
                        }
                    }
                    saveShows(decodedShows)
                }
            }
        }
    }
    
    func saveShows(_ shows:[Show])
    {
        //        print("save called")
        var watchingShows:[Show] = []
        var backlogShows:[Show] = []
        var completedShows:[Show] = []
        var droppedShows:[Show] = []
        
        for s in shows
        {
            switch s.schedual?.status
            {
            case "watching":
                watchingShows.append(s)
                break
            case "backlog":
                backlogShows.append(s)
                break
            case "completed":
                completedShows.append(s)
                break
            case "dropped":
                droppedShows.append(s)
                break
            default:
                break
            }
        }
        let showsArr = [watchingShows,backlogShows,completedShows,droppedShows]
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: showsArr, requiringSecureCoding: false)
        {
            defaults.set(savedData, forKey: showKey)
            //            print("saved")
        }
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
