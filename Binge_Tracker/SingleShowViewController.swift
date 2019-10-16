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
    
    //MARK: variables
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var statusPickerView: UIPickerView!
    @IBOutlet weak var schedualInfoLabel: UILabel!
    @IBOutlet weak var timesWatchedInfoLabel: UILabel!
    @IBOutlet weak var timesWatchedInfoStepper: UIStepper!
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

    
    //MARK: ViewDidLoad
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
        
        seasonInfoStepper.minimumValue = 1
        episodeInfoStepper.minimumValue = 1
                
        schedualInfoDatePickerView.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                
        loadStatusInfoViews()
    }
    
    
    //MARK: IBActions
    @IBAction func episodeStepperChanged(_ sender: UIStepper)
    {
        print("episode changed")
        let newValue = Int(sender.value)
        let savedShows = getShows()
        for (i, element) in savedShows.enumerated()
        {
            if let j = element.firstIndex(where: {$0.name == show.name})
            {
                savedShows[i][j].schedual!.currEpisode = newValue
                show.schedual?.currEpisode = newValue
                print("new value: \(newValue)")
            }
        }
        episodeInfoLabel.text = "episode \(newValue)"
        saveShows(showArr: savedShows)
    }
    
    @IBAction func seasonStepperChanged(_ sender: UIStepper)
    {
        print("season changed")
        let newValue = Int(sender.value)
        let savedShows = getShows()
        for (i, element) in savedShows.enumerated()
        {
            if let j = element.firstIndex(where: {$0.name == show.name})
            {
                savedShows[i][j].schedual!.currSeason = newValue
                show.schedual?.currSeason = newValue
                print("new value: \(newValue)")
            }
        }
        seasonInfoLabel.text = "season \(newValue)"
        saveShows(showArr: savedShows)
    }
    
    @IBAction func timesWatchedStepperChanged(_ sender: UIStepper)
    {
        print("times watched changed")
        let newValue = Int(sender.value)
        let savedShows = getShows()
        for (i, element) in savedShows.enumerated()
        {
            if let j = element.firstIndex(where: {$0.name == show.name})
            {
                savedShows[i][j].schedual!.timesWatched = newValue
                show.schedual?.timesWatched = newValue
                print("new value: \(newValue)")
            }
        }
        timesWatchedInfoLabel.text = "watched \(newValue) times"
        saveShows(showArr: savedShows)
    }
    
    @IBAction func datePickerChanged(_ sender: Any)
    {
        let newDate = schedualInfoDatePickerView.date
//        print("getting called \(schedualInfoDatePickerView.date)")
        let savedShows = getShows()
        for (i, element) in savedShows.enumerated()
        {
            if let j = element.firstIndex(where: {$0.name == show.name})
            {
                switch savedShows[i][j].schedual?.status
                {
                case "watching":
                    break
                case "backlog":
                    savedShows[i][j].schedual!.startDate = newDate
                    print("changing startdate to \( savedShows[i][j].schedual!.startDate)")
                    break
                case "completed":
                    savedShows[i][j].schedual!.endDate = newDate
                    print("changing enddate to \( savedShows[i][j].schedual!.endDate)")
                    break
                case "dropped":
                    break
                default:
                    break
                }
            }
        }
        saveShows(showArr: savedShows)
    }
    
    //MARK: UIPickerView
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
    
    //MARK: display correct views
    func loadStatusInfoViews()
    {
        let currStatus = statusOptions.firstIndex(of: show.schedual?.status ?? "") ?? 0
        switch currStatus
        {
        case 0: //MARK: remove
            schedualInfoLabel.isHidden = true
            schedualInfoDatePickerView.isHidden = true
            
            timesWatchedInfoLabel.isHidden = true
            timesWatchedInfoStepper.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 1: //MARK: watching
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "current episode"
            schedualInfoDatePickerView.isHidden = true
            
            timesWatchedInfoLabel.isHidden = false
            timesWatchedInfoLabel.text = "watched \(show.schedual?.timesWatched ?? -1) times"
            timesWatchedInfoStepper.isHidden = false
            timesWatchedInfoStepper.value = Double(show.schedual?.timesWatched ?? -1)
            
            if show.info["Type"] != "movie"
            {
                seasonInfoLabel.isHidden = false
                seasonInfoLabel.text = "season \(show.schedual?.currSeason ?? -1)"
                seasonInfoStepper.isHidden = false
                seasonInfoStepper.value = Double(show.schedual?.currSeason ?? -1)
                
                episodeInfoLabel.isHidden = false
                episodeInfoLabel.text = "episode \(show.schedual?.currEpisode ?? -1)"
                episodeInfoStepper.isHidden = false
                episodeInfoStepper.value = Double(show.schedual?.currEpisode ?? -1)
            }
            else
            {
                seasonInfoLabel.isHidden = true
                seasonInfoStepper.isHidden = true
                
                episodeInfoLabel.isHidden = true
                episodeInfoStepper.isHidden = true
            }
            break
        case 2: //MARK: backlog
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "start on"
            schedualInfoDatePickerView.isHidden = false
            schedualInfoDatePickerView.setDate(show.schedual?.startDate ?? Date(), animated: true)
            
            timesWatchedInfoLabel.isHidden = true
            timesWatchedInfoStepper.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 3: //MARK completed
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "completed on"
            schedualInfoDatePickerView.isHidden = false
            schedualInfoDatePickerView.setDate(show.schedual?.endDate ?? Date(), animated: true)
            
            timesWatchedInfoLabel.isHidden = true
            timesWatchedInfoStepper.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
            break
        case 4: //MARK: dropped
            schedualInfoLabel.isHidden = false
            schedualInfoLabel.text = "dropped on episode"
            schedualInfoDatePickerView.isHidden = true
            
            timesWatchedInfoLabel.isHidden = false
            timesWatchedInfoLabel.text = "watched \(show.schedual?.timesWatched ?? 0) times"
            timesWatchedInfoStepper.isHidden = false
            timesWatchedInfoStepper.value = Double(show.schedual?.timesWatched ?? -1)

            if show.info["Type"] != "movie"
            {
                seasonInfoLabel.isHidden = false
                seasonInfoLabel.text = "season \(show.schedual?.currSeason ?? -1)"
                seasonInfoStepper.isHidden = false
                seasonInfoStepper.value = Double(show.schedual?.currSeason ?? -1)
                
                episodeInfoLabel.isHidden = false
                episodeInfoLabel.text = "episode \(show.schedual?.currEpisode ?? -1)"
                episodeInfoStepper.isHidden = false
                episodeInfoStepper.value = Double(show.schedual?.currEpisode ?? -1)
            }
            else
            {
                seasonInfoLabel.isHidden = true
                seasonInfoStepper.isHidden = true
                
                episodeInfoLabel.isHidden = true
                episodeInfoStepper.isHidden = true
            }

            break
        default://MARK: default
            schedualInfoLabel.isHidden = true
            schedualInfoDatePickerView.isHidden = true
            
            timesWatchedInfoLabel.isHidden = true
            timesWatchedInfoStepper.isHidden = true
            
            seasonInfoLabel.isHidden = true
            seasonInfoStepper.isHidden = true
            
            episodeInfoLabel.isHidden = true
            episodeInfoStepper.isHidden = true
        }

    }
    
}
