//
//  ImageScanningVC.swift
//  ATNT
//
//  Created by Sam Pin Sang on 11/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON

class ImageScanningVC: UIViewController {

    let documentPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    @IBOutlet weak var foodNameTextfield: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodCalTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let pics = UserDefaultManager.getData(key: "foodImage") as? String {
            
            let docs = documentPath[0]
            let fullPath = docs.appending("/\(pics)")
            
            if let img = UIImage(contentsOfFile: fullPath) {
                foodImage.image = img
                getImageData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getImageData(){
        
        //HUD.show(.label("Analyzing Image Data"))
        HUD.show(.labeledProgress(title: "Plase wait", subtitle: "Analyzing Image Data"))
        
        let isUrl =  "http://192.168.1.100:81/property/public/api/basic/api_food_result"
        /*
        Alamofire.request(isUrl).responseString { (response) in
            print("0")
            print(response.request as Any)  // original URL request
            print("1")
            print(response.response as Any) // URL response
            print("2")
            print(response.result.value as Any)
        }
        */
        let parameters: Parameters = [
        "food_id": "1"
        ]
        
        Alamofire.request(isUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
            
            //print("0")
            //print(dataResponse.request as Any)  // original URL request
            //print("1")
            //print(dataResponse.response as Any) // URL response
            //print("2")
            //print(dataResponse.result.value as Any)
            
            if let json = dataResponse.result.value {
                
                if let dict = json as? NSDictionary {
                    
                    
                    print(dict.value(forKey: "calories")!)
                    
                    if let _ = dict.value(forKey: "food_name")  {
                        self.foodNameTextfield.text = (dict.value(forKey: "food_name") as! String)
                    }
                    
                    if let _ = dict.value(forKey: "calories") {
                        self.foodCalTextfield.text = String(describing: dict.value(forKey: "calories") as! NSNumber)
                    }
                    
                    //food_name
                    HUD.hide(afterDelay: 1)
                    
                    /*
                     calcium = 1;
                     calories = 350;
                     carbohydrates = 1;
                     cholesterol = 1;
                     "created_at" = "<null>";
                     "deleted_at" = "<null>";
                     fat = 1;
                     "food_name" = "Plain Sugar Donut";
                     id = 1;
                     iron = 1;
                     protein = 1;
                     "serving_size" = 200;
                     sodium = 1;
                     sugar = 1;
                     "updated_at" = "<null>";
                    */
                }
            }
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
