//
//  MyMessageTableViewCell.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 21.05.2022.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
