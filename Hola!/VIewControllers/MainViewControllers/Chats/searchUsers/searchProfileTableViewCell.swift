//
//  searchProfileTableViewCell.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 21.05.2022.
//

import UIKit

class searchProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
