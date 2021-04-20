//
//  TableViewCell.swift
//  KeydetGoo
//
//  Created by brian lipscomb on 2/20/18.
//  Copyright © 2018 codewithlips. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var BuildLbl: UILabel!
    @IBOutlet weak var facilLbl: UILabel!
    @IBOutlet weak var facilNumLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
