//
//  addShowViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 10/3/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class addShowViewController: UIViewController {
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var showInfoLabel: UILabel!
    @IBOutlet weak var showPlotLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var show: Show = Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    
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
                            {
                                plotString = "\(plot)"
                            }
                            if let genre = dictonary?["Genre"]
                            {
                                infoString.append("Genre: \(genre) \n")
                            }
                            if let release = dictonary?["Released"]
                            {
                                infoString.append("Release Date: \(release) \n")
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
