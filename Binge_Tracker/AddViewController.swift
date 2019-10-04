//
//  AddViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/25/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit
import Foundation

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var searchResults: [Show] = []
    var selected: Show?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsTableView.rowHeight = 100
        loadingView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selected = searchResults[indexPath.item]
        performSegue(withIdentifier: "show", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! addShowViewController
        vc.show = selected ?? Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        print(searchResults)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchResultTableViewCell
        
        let searchItem = searchResults[indexPath.item]
        
        cell.searchResultImage.image = searchItem.image
        cell.searchResultTitleLable.text = searchItem.name
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == ""
        {
            searchResults = []
            resultsTableView.reloadData()
        } else { searchForShow(query: searchText) }

    }
    
    func searchForShow(query: String)
    {
        let query_str = query.replacingOccurrences(of: " ", with: "%20")
        
        let headers = [
            "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
            "x-rapidapi-key": apiKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://movie-database-imdb-alternative.p.rapidapi.com/?page=1&r=json&s=" + query_str)! as URL,
              cachePolicy: .useProtocolCachePolicy,
              timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler:
        { (data, response, error) -> Void in
            if (error != nil)
            {
//                print(error)
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.loadingView.startAnimating()
                    self.loadingView.isHidden = false
                }
                var return_val: [Show] = []
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode ?? 400 < 300
                {
                    do
                    {
                        let dictonary =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
//                        print(dictonary)
                        if let searches = dictonary?["Search"] as? [[String:String]]
                        {
                            for search in searches
                            {
//                                print(search)
                                
                                let title = search["Title"] ?? "N/A"
                                let poster_url = search["Poster"]
                                var poster = UIImage(named: "image_not_found")!
                                if (poster_url != nil)
                                {
                                    let url = URL(string: poster_url!)
                                    let data = try? Data(contentsOf: url!)
                                    //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                    if (data != nil)
                                    {
                                        poster = UIImage(data: data!) ?? UIImage(named: "image_not_found")!
                                    }
                                }
                                return_val.append(Show(_name: title, _image: poster, _info: search))
                            }
                        }
                    }
                    catch let error as NSError
                    {
                        print("found error: ", error)
                    }
                }
                print(return_val)
                DispatchQueue.main.async
                {
                    self.searchResults = return_val
                    self.resultsTableView.reloadData()
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
//                self.resultsTableView.reloadData()
            }
        })
        dataTask.resume()
//        self.resultsTableView.reloadData()
        return
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
