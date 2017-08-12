//
//  BluetoohVC.swift
//  ATNT
//
//  Created by Sam Pin Sang on 11/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit
import CoreBluetooth
import PKHUD
import Alamofire
import SwiftyJSON

//CBPeripheralDelegate
class BluetoohVC: UIViewController, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var manager : CBCentralManager!
    var datas: [(name:String, deviceid:String)] = []
    var miband : CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CBCentralManager(delegate: self , queue: nil)
        
        myTable.delegate = self
        myTable.dataSource = self
        
        backBtn.layer.cornerRadius = 15
        backBtn.layer.borderWidth = 1
        //let dic =  UserDefaultManager.getData(key: "pairDevice") as? NSDictionary
        
        //print(dic as Any)
    }
    
    //MARK - public function
    func contains(a:[(String, String)], v:(String,String)) -> Bool {
        
        let (c1, c2) = v
        
        for (v1, v2) in a {
            
            if v1 == c1 && v2 == c2 { return true }
        }
        
        return false
    }
    
    //MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    //MARK - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = datas[indexPath.row]
        manager.stopScan()
        
        HUD.show(.labeledProgress(title: "Syncing Data", subtitle: ""))
        
        let isUrl =  "http://192.168.1.100:81/property/public/api/basic/api_device_call"
        let parameters: Parameters = [
            "height": 175,
            "weight": 72,
            "device_id": "123456"
        ]
        
        Alamofire.request(isUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
            
//            print("0")
//            print(dataResponse.request as Any)  // original URL request
//            print("1")
//            print(dataResponse.response as Any) // URL response
//            print("2")
            print(dataResponse.result.value as Any)
            
            if let json = dataResponse.result.value {
                
                let saveDict = NSMutableDictionary()
                
                if let dict = json as? NSDictionary {
                    
                    if let _ = dict.value(forKey: "status")  {
                        //self.foodNameTextfield.text = (dict.value(forKey: "food_name") as! String)
                        print(dict.value(forKey: "status") as! String)
                        
                        saveDict.setValue(dict.value(forKey: "status") as! String, forKey: "status")
                    }
                    
                    if let _ = dict.value(forKey: "bmi") {
                        saveDict.setValue(dict.value(forKey: "bmi") as! String, forKey: "bmi")
                        
                        //self.foodCalTextfield.text = String(describing: dict.value(forKey: "calories") as! NSNumber)
                    }
                    
                    if let _ = dict.value(forKey: "name") {
                        saveDict.setValue(dict.value(forKey: "name") as! String, forKey: "name")
                    }
                    
                    if let _ = dict.value(forKey: "heartbeat") {
                        saveDict.setValue(String(describing: dict.value(forKey: "heartbeat") as! NSNumber), forKey: "heartbeat")
                    }
                    
                    if let _ = dict.value(forKey: "calories") {
                        saveDict.setValue(dict.value(forKey: "calories") as! String, forKey: "calories")
                    }
                    
                    saveDict.setValue(data.deviceid, forKey: "uuid")
                    UserDefaultManager.saveData(key: "pairDevice", value: saveDict)
                    
                    /*
                     bmi = overweight;
                     calories = 300;
                     heartbeat = 80;
                     name = Wakka;
                     status = connected;
                    */
                    
                    //food_name
                    HUD.hide(afterDelay: 1)
                    
                    self.myTable.reloadData()
                }
            }
        }
        /*
        HUD.flash(.labeledProgress(title: "Syncing Data", subtitle: nil), delay: 3.0){ finished in
            
            self.dismiss(animated: true, completion: {
                
            })
        }
        */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifer = "BTCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) as! BTCell
        
        let data = datas[indexPath.row]
        cell.selectionStyle = .none
        
        if let dic =  UserDefaultManager.getData(key: "pairDevice") as? NSDictionary {
            
            let uuid = dic.value(forKey: "uuid") as! String
            cell.pairedTextfield.text = ""
            
            if (uuid == data.deviceid) {
                cell.pairedTextfield.text = "Connected"
            }else{
                cell.pairedTextfield.text = ""
            }
            
        }
        
        cell.noTextfield.text = String(indexPath.row + 1)
        cell.deviceTextfield?.text = data.name
        cell.uuidTextfield?.text = data.deviceid
        
        return cell
        
    }
    
    //MARK- CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let _ = peripheral.name {
            
            //print("Device : \(peripheral.name!) == \(peripheral.identifier.uuidString)")
            
            if contains(a: datas, v: (peripheral.name!, peripheral.identifier.uuidString)) {
                
            }else {
                
                if (peripheral.name == "MI Band 2") {
                    datas.append((name: peripheral.name!, deviceid: peripheral.identifier.uuidString))
                    print("Device : \(peripheral.name!) == \(peripheral.identifier.uuidString)")
                    //print("count = \(datas.count)")
                    self.myTable.reloadData()
                }
            }
            
            if (peripheral.name == "MI Band 2") {
                //self.miband = peripheral
                //self.miband.delegate = self
                //manager.stopScan()
                //manager.connect(self.miband, options: nil)
                
            }
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("didConnect")
        if let servicePeri = peripheral.services as [CBService]! {
            
            for service in servicePeri
            {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let charArray = service.characteristics as [CBCharacteristic]!
        {
            for cc in charArray
            {
                
                if(cc.uuid.uuidString == "FF06")
                {
                    print("schritte gefunden")
                    peripheral.readValue(for: cc)
                }
                
            }
        }
        
    }
    
    
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        
        switch (central.state) {
            
        case .poweredOff:
            msg = "poweredOff"
        case .poweredOn:
            msg = "poweredOn"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            msg = "resetting"
        case .unauthorized:
            msg = "unauthorized"
        case .unsupported:
            msg = "unsupported"
        case .unknown:
            msg = "unknown"
            
        default:
            break
        }
        
        print(msg)
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        
        dismiss(animated: true) { 
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
