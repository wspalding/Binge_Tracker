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
    
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var showInfoLabel: UILabel!
    @IBOutlet weak var showPlotLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var statusPickerView: UIPickerView!
    
    let statusOptions = ["", "backlog", "watching", "completed", "dropped"]
    var show: Show = Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
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
                            { plotString = "\(plot)" }
                            
                            if let type = dictonary?["Type"]
                            { infoString.append("Type: \(type)\n") }
                            
                            if let genre = dictonary?["Genre"]
                            { infoString.append("Genre: \(genre)\n") }
                            
                            if let release = dictonary?["Released"]
                            { infoString.append("Release Date: \(release)\n") }
                            
                            if let metaScore = dictonary?["Metascore"]
                            { infoString.append("Metascore: \(metaScore)\n") }
                            
                            if let imdbRating = dictonary?["imdbRating"]
                            { infoString.append("imdbRating: \(imdbRating)\n") }
                            
                            if let runTime = dictonary?["Runtime"]
                            { infoString.append("Runtime: \(runTime)\n") }
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
            print(stat)
            if let savedShows = defaults.object(forKey: showKey) as? Data
            {
                if var decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [Show]
                {
                    for s in decodedShows
                    {
                        if s.name == show.name
                        {
                            found = true
                            s.addSchedual(_schedual: Schedual(_status: stat))
                        }
                    }
                    if !found
                    {
                        show.addSchedual(_schedual: Schedual(_status: stat))
                        decodedShows.append(show)
                    }
                    saveShows(decodedShows)
                }
            }
            else
            {
                show.addSchedual(_schedual: Schedual(_status: stat))
                saveShows([show])
            }
        }
        
    }
    
    func saveShows(_ shows:[Show])
    {
//        print("save called")
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: shows, requiringSecureCoding: false)
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
