//
//  createShowViewController.swift
//  Binge_Tracker
//
//  Created by William Spalding on 10/17/19.
//  Copyright © 2019 William Spalding. All rights reserved.
//

import UIKit

class createShowViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
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
    
    var imagePicker = UIImagePickerController()
    
    var newShow: Show?
    
    
    //MARK: viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        plotTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        plotTextView.layer.borderWidth = 0.5
        plotTextView.layer.cornerRadius = 5.0
        
        imagePicker.delegate = self
        
    }
    
    
    //MARK: IBActions
    @IBAction func addImageButtonPressed(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
//            print("Button capture")
            
            imagePicker.sourceType = .photoLibrary
//            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func createShowButtonPressed(_ sender: UIButton)
    {
        if let title = titleTextField.text
        {
            if title != ""
            {
                let info: [String:String] = [
                    "Type": typeTextField.text ?? "custum",
                    "Genre": genreTextField.text ?? "n/a",
                    "Released": releaseDateTextField.text ?? "n/a",
                    "Metascore":metaScoreTextField.text ?? "n/a",
                    "imdbRating": imdbRatingTextField.text ?? "n/a",
                    "Runtime": runtimeTextField.text ?? "n/a",
                    "totalSeasons": numberOfSeasonsTextField.text ?? "n/a"]
                newShow = Show(_name: title, _image: imageButton.image(for: UIControl.State.normal), _info: info)
                titleTextField.layer.borderWidth = 0.0
                performSegue(withIdentifier: "show3", sender: self)
            }
            else
            {
                titleTextField.layer.borderColor = UIColor.red.cgColor
                titleTextField.layer.borderWidth = 0.5
                titleTextField.layer.cornerRadius = 5.0
            }
        }
    }
    
    //MARK: Set Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
//        print("setting image")
        if let image = info[.originalImage] as? UIImage
        {
            let aspectHeight = imageButton.frame.height / image.size.height
            let aspectWidth = imageButton.frame.width / image.size.width
            let aspectRatio = min(aspectHeight, aspectWidth)
            let newHeight = image.size.height * aspectRatio
            let newWidth = image.size.width * aspectRatio
            print("image frame = \(imageButton.frame.height)x\(imageButton.frame.width)")
            print("new image size = \(newHeight)x\(newWidth)")
            let newImage = resizeImage(image: image, to: CGSize(width: newWidth, height: newHeight))
            imageButton.imageView?.contentMode = .scaleAspectFit
            imageButton.setImage(newImage.withRenderingMode(.alwaysOriginal), for: UIControl.State.normal)
            imageButton.setTitle("", for: UIControl.State.normal)

            dismiss(animated: true, completion: nil)
        }
    }
    
    func resizeImage(image: UIImage, to newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SingleShowViewController
        vc.show = newShow ?? Show(_name: "N/A", _image: UIImage(named: "image_not_found")!, _info: [:])
    }

}
