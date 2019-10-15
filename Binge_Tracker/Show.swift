//
//  Show.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/24/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

//enum Status
//{
//    case finishd
//    case watching
//    case backlog
//    case dropped
//}

let sectionHeaders = ["watching","backlog","completed","dropped"]

class Show: NSObject, NSCoding
{
    var name: String
    var image: UIImage
    var info: [String:String]
    var schedual: Schedual?
    override var description: String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.none
        
        if let s = schedual
        {
            switch schedual?.status
            {
            case "watching":
                return "on season \(s.currSeason) episode \(s.currEpisode)"
            case "backlog":
                return "starting on \(dateformatter.string(from: s.startDate))"
            case "completed":
                return "finished on \(dateformatter.string(from: s.endDate))"
            case "dropped":
                return "dropped on season \(s.currSeason) episode \(s.currEpisode)"
            default:
                return ""
            }
        }
        return ""
    }
    
    init(_name:String, _image: UIImage?, _info: [String:String], _schedual:Schedual? = nil)
    {
        name = _name
        image = _image ?? UIImage(named: "image_not_found")!
        info = _info
        schedual = _schedual
    }
    
    func addSchedual(_schedual: Schedual)
    {
        schedual = _schedual
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "nameKey")
        aCoder.encode(image, forKey: "imageKey")
        aCoder.encode(info, forKey: "infoKey")
        aCoder.encode(schedual, forKey: "schedualKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "nameKey") as? String ?? "ERROR"
        image = aDecoder.decodeObject(forKey: "imageKey") as? UIImage ?? UIImage(named: "image_not_found")!
        info = aDecoder.decodeObject(forKey: "infoKey") as? [String:String] ?? [:]
        schedual = aDecoder.decodeObject(forKey: "schedualKey") as? Schedual ?? nil
    }
}

class Schedual: NSObject, NSCoding
{
    var status: String
    var currEpisode: Int
    var currSeason: Int
    var startDate: Date
    var endDate: Date
    
    init(_status: String, _currEpisode: Int = 1, _currSeason: Int = 1, _startDate: Date = Date(), _endDate: Date = Date())
    {
        status = _status
        currEpisode = _currEpisode
        currSeason = _currSeason
        startDate = _startDate
        endDate = _endDate
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(status, forKey: "statusKey")
        aCoder.encode(currEpisode, forKey: "currEpisodeKey")
        aCoder.encode(currSeason, forKey: "currSeasonKey")
        aCoder.encode(startDate, forKey: "startDateKey")
        aCoder.encode(endDate, forKey: "endDateKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        status = aDecoder.decodeObject(forKey: "statusKey") as? String ?? ""
        currEpisode = aDecoder.decodeObject(forKey: "currEpisodeKey") as? Int ?? 1
        currSeason = aDecoder.decodeObject(forKey: "currSeasonKey") as? Int ?? 1
        startDate = aDecoder.decodeObject(forKey: "startDateKey") as? Date ?? Date()
        endDate = aDecoder.decodeObject(forKey: "endDateKey") as? Date ?? Date()
    }
}

func saveShows(showArr: [[Show]])
{
    let defaults = UserDefaults.standard
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: showArr, requiringSecureCoding: false)
    {
        defaults.set(savedData, forKey: showKey)
        //            print("saved")
    }
}

func getShows() -> [[Show]]
{
//    print("getting shows array")
    let defaults = UserDefaults.standard
    if let savedShows = defaults.object(forKey: showKey) as? Data
    {
        if let decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [[Show]]
        {
            return decodedShows
        }
    }
//    print("none found")
    return Array(repeating: [], count: sectionHeaders.count)
}

func getShow(with name:String) -> Show?
{
    let defaults = UserDefaults.standard
    if let savedShows = defaults.object(forKey: showKey) as? Data
    {
        if let decodedShows = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedShows) as? [[Show]]
        {
            for (i, sArr) in decodedShows.enumerated()
            {
                if let index = sArr.firstIndex(where: {$0.name == name})
                {
                    return decodedShows[i][index]
                }
            }
        }
    }
    return nil
}

func removeShow(with name: String, shows:[[Show]]) -> [[Show]]
{
    var rShows = shows
    for (i, sArr) in rShows.enumerated()
    {
        if let index = sArr.firstIndex(where: {$0.name == name})
        {
            rShows[i].remove(at: index)
        }
    }
    return rShows
}

func moveShow(with name: String, to index2: Int, shows:[[Show]]) -> [[Show]]
{
    var rShows = shows
    var index1:Int
    {
        for (i, sArr) in rShows.enumerated()
        {
            if let _ = sArr.firstIndex(where: {$0.name == name})
            {
                return i
            }
        }
        return index2
    }
    if(index1 == index2) {return shows}
    if let i = rShows[index1].firstIndex(where: {$0.name == name})
    {
        let element = rShows[index1].remove(at: i)
        element.schedual?.status = sectionHeaders[index2]
        if !rShows[index2].contains(where: {$0.name == name})
        {
            rShows[index2].append(element)
        }
    }
    return rShows
}


