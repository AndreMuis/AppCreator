//
//  APCImageViewController.swift
//  AppCreator
//
//  Created by Andre Muis on 5/31/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class APCImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate : APCImageViewControllerDelegate?
    var image : APCImage?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(nibName: String?, bundle: NSBundle?)
    {
        super.init(nibName: nibName, bundle: bundle)
        
        self.delegate = nil
        self.image = nil
    }
    
    @IBAction func addImageTapped(sender: AnyObject)
    {
        let image = APCImage(filePathURL: NSURL(fileURLWithPath: ""))
        
        self.delegate?.imageViewController(self, addImage: image)
    }

    @IBAction func selectImageTapped(sender: AnyObject)
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true)
        {
            let picker : UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }

    @IBAction func deleteImageTapped(sender: AnyObject)
    {
        self.delegate?.imageViewController(self, deleteImage: self.image!)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let uiImage : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = uiImage
        
            self.image?.uiImage = uiImage
            
            
            let paths : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                                       NSSearchPathDomainMask.UserDomainMask,
                                                                       true)

            self.image!.filePathURL = NSURL(fileURLWithPath: "\(paths[0])/Image.png")
            
            
            print(self.image!.filePathURL)
            
            UIImagePNGRepresentation(uiImage)?.writeToFile("\(paths[0])/Image.png", atomically: true)
            
            
            self.delegate?.imageViewController(self, didModifyImage: self.image!)
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

















