//
//  UserDefaultManager.swift
//  ATNT
//
//  Created by Sam Pin Sang on 11/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {
    
    
    static func saveData(key:String, value:Any){
        
        let userDefault = UserDefaults.standard
        userDefault.setValue(value, forKey: key)
        userDefault.synchronize()
        
    }
    
    static func getData(key:String)-> Any? {
        
        let userDefault = UserDefaults.standard
        if let data = userDefault.value(forKey: key) {
            return data
        }
        
        return nil
    }
    
    static func removeData(key:String)-> Bool{
        
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        return userDefault.synchronize()
        
    }
}
