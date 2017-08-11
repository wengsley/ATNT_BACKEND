//
//  BTCell.swift
//  ATNT
//
//  Created by Sam Pin Sang on 12/08/2017.
//  Copyright © 2017 samgdx. All rights reserved.
//

import UIKit

class BTCell: UITableViewCell {

    @IBOutlet weak var noTextfield: UILabel!
    @IBOutlet weak var deviceTextfield: UILabel!
    @IBOutlet weak var uuidTextfield: UILabel!
    @IBOutlet weak var pairedTextfield: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
