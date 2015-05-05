//
//  TweetCell.swift
//  Tweet
//
//  Created by Elaine Mao on 5/4/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
