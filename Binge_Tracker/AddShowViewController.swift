//
//  addShowViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 10/3/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class addShowViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK: variables
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var showInfoLabel: UILabel!
    @IBOutlet weak var showPlotLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var statusPickerView: UIPickerView!
    @IBOutlet weak var schedualInfoLabel: UILabel!
    @IBOutlet weak var timesWatchedInfoLabel: UILabel!
    @IBOutlet weak var timesWatchedInfoStepper: UIStepper!
    @IBOutlet weak var seasonInfoLabel: UILabel!
    @IBOutlet weak var seasonInfoStepper: UIStepper!
    @IBOutlet weak var episodeInfoLabel: UILabel!
    @IBOutlet weak var episodeInfoStepper: UIStepper!
    @IBOutlet weak var schedualInfoDatePickerView: UIDatePicker!
    
    let statusOptions = [""] + sectionHeaders
    var show: Show = Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    let defaults = UserDefaults.standard
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showTitleLabel.text = show.name
        posterImage.image = show.image
        loadingView.isHidden = true
        showPlotLabel.isHidden = true
        showInfoLabel.isHidden = true
        
        var infoString = ""
        var plotString = ""
        
        if let id = show.info["imdbID"]
        {
            let headers = [
                "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
                "x-rapidapi-key": apiKey
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://movie-database-imdb-alternative.p.rapidapi.com/?i=" + id + "&r=json")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            

            self.loadingView.startAnimating()
            self.loadingView.isHidden = false
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
                if (error != nil)
                {
//                    print(error)
                }
                else
                {
                    let httpResponse = response as? HTTPURLResponse
                    if httpResponse?.statusCode ?? 400 < 300
                    {
                        do
                        {
                            let dictonary =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
//                            print(dictonary)
                            if let plot = dictonary?["Plot"]
                            {
                                plotString = "\(plot)"
                                self.show.info["Plot"] = plotString
                            }
                            
                            if let type = dictonary?["Type"]
                            {
                                infoString.append("Type: \(type)\n")
                                self.show.info["Type"] = type as? String
                            }
                            
                            if let genre = dictonary?["Genre"]
                            {
                                infoString.append("Genre: \(genre)\n")
                                self.show.info["Genre"] = genre as? String
                            }
                            
                            if let release = dictonary?["Released"]
                            {
                                infoString.append("Release Date: \(release)\n")
                                self.show.info["Released"] = release as? String
                            }
                            
                            if let metaScore = dictonary?["Metascore"]
                            {
                                infoString.append("Metascore: \(metaScore)\n")
                                self.show.info["Metascore"] = metaScore as? String
                            }
                            
                            if let imdbRating = dictonary?["imdbRating"]
                            {
                                infoString.append("imdbRating: \(imdbRating)\n")
                                self.show.info["imdbRating"] = imdbRating as? String
                            }
                            
                            if let runTime = dictonary?["Runtime"]
                            {
                                infoString.append("Runtime: \(runTime)\n")
                                self.show.info["Runtime"] = runTime as? String
                            }
                            
                            if let totalSeasons = dictonary?["totalSeasons"]
                            {
                                infoString.append("totalSeasons: \(totalSeasons)\n")
                                self.show.info["totalSeasons"] = totalSeasons as? String
//                                self.seasonInfoStepper.maximumValue = totalSeasons as! Double

                            }
                        }
                        catch let error as NSError
                        {
                            print("found error: ", error)
                        }
                    }
                    DispatchQueue.main.async
                    {
                        self.loadingView.stopAnimating()
                        self.loadingView.isHidden = true
                        
                        self.showInfoLabel.text = infoString
                        self.showInfoLabel.isHidden = false
                        
                        self.showPlotLabel.text = plotString
                        self.showPlotLabel.isHidden = false
                    }
                }
            })
            
            dataTask.resume()
        }
        showInfoLabel.text = infoString
        
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
