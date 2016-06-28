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
    @IBOutlet weak var moveUpButton: UIButton!
    @IBOutlet weak var moveDownButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var delegate : APCImageViewControllerDelegate?
    
    var image : APCImage?
    {
        didSet
        {
            self.imageView.image = self.image?.uiImage ?? UIImage(named: APCConstants.noPhotoImageName)

            self.saveButton.enabled = self.image != nil ? true : false
            self.moveUpButton.enabled = self.image != nil ? true : false
            self.moveDownButton.enabled = self.image != nil ? true : false
            self.deleteButton.enabled = self.image != nil ? true : false
        }
    }
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.imageView.image = UIImage(named: APCConstants.noPhotoImageName)
        
        self.saveButton.enabled = false
        self.moveUpButton.enabled = false
        self.moveDownButton.enabled = false
        self.deleteButton.enabled = false
        
        let gestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                                action: #selector(APCImageViewController.handleTap))
        
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func addButtonTapped(sender: AnyObject)
    {
        if self.imageView.image != UIImage(named: APCConstants.noPhotoImageName)
        {
            if let delegate : APCImageViewControllerDelegate = self.delegate,
                uiImage : UIImage = self.imageView.image,
                image : APCImage = APCImage(uiImage: uiImage)
            {
                delegate.imageViewController(self, addImage: image)
            }
        }
    }

    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        if let image : APCImage = self.image,
            uiImage : UIImage = self.imageView.image,
            imageData : NSData = UIImagePNGRepresentation(uiImage)
        {
            if imageData.writeToURL(image.fileURL, atomically: true) == true
            {
                image.uiImage = uiImage
            }
            else
            {
                print("Unable to save UIImage data to a file.")
            }
        }
    }
    
    @IBAction func moveUpButtonTapped(sender: AnyObject)
    {
        if let delegate : APCImageViewControllerDelegate = self.delegate,
            image : APCImage = self.image
        {
            delegate.imageViewController(self, moveImage: image, moveDirection: APCMoveDirection.Up)
        }
    }
    
    @IBAction func moveDownButtonTapped(sender: AnyObject)
    {
        if let delegate : APCImageViewControllerDelegate  = self.delegate,
            image : APCImage = self.image
        {
            delegate.imageViewController(self, moveImage: image, moveDirection: APCMoveDirection.Down)
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject)
    {
        if let delegate : APCImageViewControllerDelegate  = self.delegate,
            image : APCImage = self.image
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
        else
        {
            print("Image picker \"photo library\" source type is not available.")
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let uiImage : UIImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = uiImage.resizedJPEGImage(maxSideLength: APCConstants.appleWatchMaxScreenWidth,
                                                            jpegCompressionQuality: APCConstants.jpegCompressionQuality)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK:
}












