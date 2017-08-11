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

class ImageScanningVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let documentPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    @IBOutlet weak var foodNameTextfield: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodCalTextfield: UITextField!
    @IBOutlet weak var myTable: UITableView!
    
    
    var items : [(name:String, kcal:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myTable.delegate = self
        myTable.dataSource = self
        
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
    
    //MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifer = "BTCellTwo"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) as! BTCell
        
        let data = items[indexPath.row]
        
        
        cell.pairedTextfield.text = ""
        cell.noTextfield.text = String(indexPath.row + 1)
        cell.deviceTextfield?.text = data.name
        cell.uuidTextfield?.text = data.kcal+" kcal"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = items[indexPath.row]
        let isUrl =  "http://192.168.1.100:81/property/public/api/basic/api_compare_food"
        
        let parameters: Parameters = [
            "calories": data.kcal
        ]
        
        Alamofire.request(isUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
            
            if let json = dataResponse.result.value {
                
                if let dict = json as? NSDictionary {
                    
                    let msg = dict.value(forKey: "message") as? String
                    var alertMsg = ""
                    
                    if (msg == "bad"){
                        alertMsg = "This food is bad for your health"
                    }else{
                        alertMsg = "This food is good to take"
                    }
                    
                    let alert = UIAlertController(title: alertMsg, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        
                    })
                }
            }
            
//            if let json = dataResponse.result.value {
//                
//                if let dict = json as? NSDictionary {
//                    
//                    
//                    print(dict.value(forKey: "calories")!)
//                    
//                    if let _ = dict.value(forKey: "food_name")  {
//                        self.foodNameTextfield.text = (dict.value(forKey: "food_name") as! String)
//                    }
//                    
//                    if let _ = dict.value(forKey: "calories") {
//                        self.foodCalTextfield.text = String(describing: dict.value(forKey: "calories") as! NSNumber)
//                    }
//                    
//                    //food_name
//                    HUD.hide(afterDelay: 1)
//                    
//                    
//                }
//            }
        }
        
    }
    
    //MARK - public function
    func getImageData(){
        
        //HUD.show(.label("Analyzing Image Data"))
        HUD.show(.labeledProgress(title: "Plase wait", subtitle: "Analyzing Image Data"))
        
        //let isUrl =  "http://192.168.1.100:81/property/public/api/basic/api_food_result"
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
        /*
        let parameters: Parameters = [
        "food_id": "1"
        ]
        */
        /*
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
                    
                    
                }
            }
        }
        */
        
        let upUrl = "https://api-2445582032290.production.gw.apicast.io/v1/foodrecognition?user_key=610cf1afd9bed8b39ac17b363d071625"
        
        let docs = documentPath[0]
        let fullPath = docs.appending("/food.png")
        
        let image = UIImage.init(contentsOfFile: fullPath)
        let size : CGSize = CGSize(width: 272, height: 272)
        let newImg = image?.scaleImage(toSize: size)
        
        print(newImg?.size.height as Any)
        print(newImg?.size.width as Any)
        
        let imgData = UIImageJPEGRepresentation(newImg!, 0.2)!
        //let parameters = ["FILE": rname]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "FILE",fileName: "image.jpg", mimeType: "image/jpg")
            
        },
        to:upUrl)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //print(response.result.value as Any)
                    HUD.hide()
                    if let json = response.result.value {
                        
                        if let dict = json as? NSDictionary {
                            
                            if let results = dict.value(forKey: "results") as? NSArray {
                                
                                if(results.count > 0){
                                    
                                    if let dict2  = results[0] as? NSDictionary {
                                        
                                        if let ary = dict2.value(forKey: "items") as? NSArray {
                                            
                                            
                                            for finalDict in ary {
                                                
                                                let tmpDic = finalDict as? NSDictionary
                                                
                                                if let tmpData = tmpDic?.value(forKey: "nutrition") as? NSDictionary {
                                                    
                                                    let tName = tmpDic?.value(forKey: "name") as! String
                                                    let tKcal = String(describing: tmpData.value(forKey: "calories") as! NSNumber)
                                                    
                                                    
                                                    self.items.append((tName, tKcal))
                                                    
                                                }
                                                
                                                //print(tmpDic as Any)
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                            //print(self.items)
                            self.myTable.reloadData()
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)  
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
