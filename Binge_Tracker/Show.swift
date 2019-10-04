//
//  Show.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/24/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

enum Status
{
    case finishd
    case watching
    case backlog
}

class Show: NSObject
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
}

class Schedual: NSObject
{
    var status: Status
    
    init(_status: Status)
    {
        status = _status
    }
}
