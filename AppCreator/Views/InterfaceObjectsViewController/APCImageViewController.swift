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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var delegate : APCImageViewControllerDelegate?
    var image : APCImage?
    {
        didSet
        {
            self.imageView.image = self.image?.uiImage ?? UIImage(named: "NoPhoto")

            self.saveButton.enabled = self.image != nil ? true : false
            self.deleteButton.enabled = self.image != nil ? true : false
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
        
        self.saveButton.enabled = false
        self.deleteButton.enabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(APCImageViewController.handleTap))
        
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if self.imageView.image != UIImage(named: "NoPhoto")
        {
            if let delegate = self.delegate,
                let uiImage = self.imageView.image,
                let image = APCImage(uiImage: uiImage)
            {
                delegate.imageViewController(self, addImage: image)
            }
        }
    }

    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if let image = self.image,
            let uiImage = self.imageView.image
        {
            if image.updateUIImage(uiImage) == false
            {
                print("unable to update uiImage on an APCImage object")
            }
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let delegate = self.delegate,
            image = self.image
        {
            delegate.imageViewController(self, deleteImage: image)
        }
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer)
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
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let uiImage : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = uiImage
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK:
}












