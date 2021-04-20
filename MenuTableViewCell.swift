//
//  MenuTableViewCell.swift
//  KeydetGoo
//
//  Created by brian lipscomb on 4/11/18.
//  Copyright © 2018 codewithlips. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {


    @IBOutlet weak var TableImage: UIImageView!
    
    @IBOutlet weak var menuTableText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
