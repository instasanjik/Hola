//
//  ProfileTableViewCell.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 17.05.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
