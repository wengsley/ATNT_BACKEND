//
//  ViewController.swift
//  ATNT
//
//  Created by Sam Pin Sang on 11/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager : CBCentralManager!
    var datas: [(name:String, deviceid:String)] = []
    var miband : CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CBCentralManager(delegate: self , queue: nil)
        
    }
    
    //MARK - public function
    func contains(a:[(String, String)], v:(String,String)) -> Bool {
        
        let (c1, c2) = v
        
        for (v1, v2) in a {
            
            if v1 == c1 && v2 == c2 { return true }
        }
        
        return false
    }
    
    //MARK- CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let _ = peripheral.name {
            
            //print("Device : \(peripheral.name!) == \(peripheral.identifier.uuidString)")
            
            if contains(a: datas, v: (peripheral.name!, peripheral.identifier.uuidString)) {
                
            }else {
                datas.append((name: peripheral.name!, deviceid: peripheral.identifier.uuidString))
                print("Device : \(peripheral.name!) == \(peripheral.identifier.uuidString)")
                print("count = \(datas.count)")
            }
            
            if (peripheral.name == "MI Band 2") {
                //self.miband = peripheral
                //self.miband.delegate = self
                manager.stopScan()
                manager.connect(self.miband, options: nil)
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

