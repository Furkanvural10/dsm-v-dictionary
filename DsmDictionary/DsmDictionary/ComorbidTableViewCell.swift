//
//  ComorbidTableViewCell.swift
//  DsmDictionary
//
//  Created by furkan vural on 29.03.2023.
//

import UIKit

class ComorbidTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var comorbirLabel1: UILabel!
    @IBOutlet weak var comorbidLabel2: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
