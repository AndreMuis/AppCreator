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
    {
        didSet
        {
            self.imageView.image = self.image?.uiImage ?? UIImage(named: "NoPhoto")
        }
    }
    var imageFileURL : String?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(nibName: String?, bundle: NSBundle?)
    {
        super.init(nibName: nibName, bundle: bundle)
        
        self.delegate = nil
        self.image = nil
        self.imageFileURL = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: "NoPhoto")
    }
    
    @IBAction func addImageTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            let uiImage = self.imageView.image,
            let image = APCImage(uiImage: uiImage)
        {
            delegate.imageViewController(self, addImage: image)
        }
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
        if let delegate = self.delegate,
            image = self.image
        {
            delegate.imageViewController(self, deleteImage: image)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let uiImage : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = uiImage
            
            if let image = self.image
            {
                if image.updateUIImage(uiImage) == false
                {
                    print("unable to update uiImage on an APCImage object")
                }
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}












