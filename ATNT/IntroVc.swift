//
//  IntroVc.swift
//  ATNT
//
//  Created by Sam Pin Sang on 12/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit

class IntroVc: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK - public functions
    @IBAction func goNext(_ sender: UIButton) {
        
        let storyb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyb.instantiateViewController(withIdentifier: "MainVC")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapStartButton(_ sender: UITapGestureRecognizer) {
        print("safasfsadf")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
