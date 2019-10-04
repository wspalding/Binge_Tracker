//
//  SearchResultTableViewCell.swift
//  Binge_Tracker
//
//  Created by William Spalding on 9/25/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var searchResultImage: UIImageView!
    @IBOutlet weak var searchResultTitleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
