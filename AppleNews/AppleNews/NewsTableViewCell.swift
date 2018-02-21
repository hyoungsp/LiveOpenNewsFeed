//
//  NewsTableViewCell.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/29/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // NewsTableView Cell properties
    // Displaying emoji, title and Subtitle
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var emoji: UIImageView!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
