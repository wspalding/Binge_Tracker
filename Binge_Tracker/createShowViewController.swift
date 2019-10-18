//
//  createShowViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 10/17/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class createShowViewController: UIViewController
{

    //MARK: variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var metaScoreTextField: UITextField!
    @IBOutlet weak var imdbRatingTextField: UITextField!
    @IBOutlet weak var runtimeTextField: UITextField!
    @IBOutlet weak var numberOfSeasonsTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        plotTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        plotTextView.layer.borderWidth = 0.5
        plotTextView.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: IBActions
    @IBAction func addImageButtonPressed(_ sender: UIButton)
    {
        
    }
    
    @IBAction func createShowButtonPressed(_ sender: UIButton)
    {
        
    }
    

}
