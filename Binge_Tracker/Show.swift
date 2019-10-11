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

class Show: NSObject, NSCoding
{
    var name: String
    var image: UIImage
    var info: [String:String]
    var schedual: Schedual?
    
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
    
    init(_status: String)
    {
        status = _status
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(status, forKey: "statusKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        status = aDecoder.decodeObject(forKey: "statusKey") as? String ?? ""
    }
}

func saveShows(showArr: [[Show]])
{
    
}

func getShows() -> [[Show]]
{
    return [[]]
}
