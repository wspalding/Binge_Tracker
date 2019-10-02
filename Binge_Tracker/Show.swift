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
    var status: Status
    var numberOfEpisodes: Int
    var numberOfSeasons: Int
    var image: UIImage
    var runTime: TimeInterval
    
    init(_name:String, _status: Status, _numberOfEpisodes: Int, _numberOfSeasons: Int, _image: UIImage?, _runTime: TimeInterval)
    {
        name = _name
        status = _status
        numberOfEpisodes = _numberOfEpisodes
        image = _image ?? UIImage(named: "image_not_found")!
        runTime = _runTime
        numberOfSeasons = _numberOfSeasons
    }
    
    
}
