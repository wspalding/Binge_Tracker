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
    @IBOutlet weak var schedualInfoLabel: UILabel!
    @IBOutlet weak var seasonInfoLabel: UILabel!
    @IBOutlet weak var seasonInfoStepper: UIStepper!
    @IBOutlet weak var episodeInfoLabel: UILabel!
    @IBOutlet weak var episodeInfoStepper: UIStepper!
    @IBOutlet weak var schedualInfoDatePickerView: UIDatePicker!
    
    let defaults = UserDefaults.standard
    var show: Show = Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    
    let statusOptions = ["remove"] + sectionHeaders
    var seasonString = "season: "
    let episodeString = "episode: "

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = show.name
        posterImage.image = show.image
        
        var infoText = ""
        infoText += "Type: \(show.info["Type"] ?? "unknown")\n"
        infoText += "Genre: \(show.info["Genre"] ?? "unknown")\n"
        infoText += "Release Date: \(show.info["Released"] ?? "unknown")\n"
        infoText += "Metascore: \(show.info["Metascore"] ?? "unknown")\n"
        infoText += "imdbRating: \(show.info["imdbRating"] ?? "unknown")\n"
        infoText += "Runtime: \(show.info["Runtime"] ?? "unknown")\n"
        if let numSeasons = show.info["totalSeasons"]
        {
            infoText += "totalSeasons: \(numSeasons)\n"
            seasonInfoStepper.maximumValue = Double(numSeasons) ?? 0
        }
        infoLabel.text = infoText
        
        plotLabel.text = show.info["Plot"]
        let currStatus = statusOptions.firstIndex(of: show.schedual?.status ?? "") ?? 0
        statusPickerView.selectRow(currStatus, inComponent: 0, animated: false)
        schedualInfoDatePickerView.datePickerMode = .date
        
        seasonInfoStepper.minimumValue = 0
        episodeInfoStepper.minimumValue = 0
        
        loadStatusInfoViews()
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any)
    {
        print("getting called")
        let savedShows = getShows()
        let savedShow = getShow(with: show.name)
        if let s = savedShow?.schedual
        {
            switch s.status
            {
            case "watching":
                break
            case "backlog":
                s.startDate = schedualInfoDatePickerView.date
                print("getting called")
                break
            case "completed":
                s.endDate = schedualInfoDatePickerView.date
                print("getting called")
                break
            case "dropped":
                break
            default:
                break
            }
        }
        saveShows(showArr: savedShows)
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
        loadStatusInfoViews()
    }
    
    func loadStatusInfoViews()
    {
        let currStatus = statusOptions.firstIndex(of: show.schedual?.status ?? "") ?? 0
        switch currStatus
        {
        case 0: //remove
            schedualInfoLabel.isHidden = true
            schedualInfoDatePickerView.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 1: //watching
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "current episode"
            schedualInfoDatePickerView.isHidden = true
            
            seasonInfoLabel.isHidden = false
            seasonInfoStepper.isHidden = false
            episodeInfoLabel.isHidden = false
            episodeInfoStepper.isHidden = false
            break
        case 2: //backlog
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "start on"
            schedualInfoDatePickerView.isHidden = false
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 3: //completed
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "completed on"
            schedualInfoDatePickerView.isHidden = false
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 4: //dropped
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "dropped on episode"
            schedualInfoDatePickerView.isHidden = true
            
            seasonInfoLabel.isHidden = false
            seasonInfoStepper.isHidden = false
            episodeInfoLabel.isHidden = false
            episodeInfoStepper.isHidden = false
            break
        default:
            schedualInfoLabel.isHidden = true
            schedualInfoDatePickerView.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
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
