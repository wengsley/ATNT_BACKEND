//
//  MainVC.swift
//  ATNT
//
//  Created by Sam Pin Sang on 11/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let documentPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        addButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        addButton.setTitle(String.fontAwesomeIcon(code: "fa-plus-circle"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBAction func captureImg(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        //avatarImageview.image = selectedImage
        
        let imageData = NSData(data:UIImagePNGRepresentation(selectedImage)!)
        let docs = documentPath[0]
        let fullPath = docs.appending("/food.png")
        print(fullPath)
        imageData.write(toFile: fullPath, atomically: true)
        
        UserDefaultManager.saveData(key: "foodImage", value: "food.png")
        //let result = imageData.writeToFile(fullPath, atomically: true)
        
        //avatarImageview.image = UIImage(data: data)
        
        
        // Set photoImageView to display the selected image.
        //photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: false) {
            
            let storyb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyb.instantiateViewController(withIdentifier: "ImageScan") as! ImageScanningVC
            //vc.foodImage.image = selectedImage
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    @IBAction func doPairing(_ sender: UIBarButtonItem) {
        
        let uistoryb = UIStoryboard.init(name: "Main", bundle: nil)
        
        let vc = uistoryb.instantiateViewController(withIdentifier: "BluetoohVC") as! BluetoohVC
        
        self.present(vc, animated: true) { 
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
