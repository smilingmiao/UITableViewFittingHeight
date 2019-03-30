//
//  AdaptiveTableViewCell.swift
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/30.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

import UIKit

class AdaptiveTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  func bindData(current feed: FeedItem) {
    titleLabel.text = feed.title
    contentLabel.text = feed.content
  }
  
}
