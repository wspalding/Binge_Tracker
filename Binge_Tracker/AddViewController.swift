//
//  AddViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/25/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    var searchReasults: [(String, UIImage)] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultsTableView.rowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchReasults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchResultTableViewCell
        cell.searchResultImage.image = searchReasults[indexPath.item].1
        cell.searchResultTitleLable.text = searchReasults[indexPath.item].0
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForShow(query: searchText)
//        resultsTableView.rowHeight = UITableView.automaticDimension
//        resultsTableView.estimatedRowHeight = 100
        resultsTableView.reloadData()
    }
    
    func searchForShow(query: String)
    {
        let image = UIImage(named: "iconfinder_video_call_2639945") ?? UIImage(named: "image_not_found")!
        
        // make HTTPS request here
        let key = "5b22867e"
//        let key = "bea0628b-f412-44e7-aba8-16ad02bf6f38"
//        let session = URLSession.shared
        let query_str = query.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://omdbapi.com/?apikey=" + key + "&s=" + query_str)!
//        print(url)
        
        let task = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            
            if let data = data
            {
                do
                {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    print("json: ", jsonSerialized!)
                   
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
            }
            else if let error = error
            {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
        searchReasults = [("test", image)]
        
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
