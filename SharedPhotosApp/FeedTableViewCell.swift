//
//  FeedTableViewCell.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 5.08.2024.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userCommentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
