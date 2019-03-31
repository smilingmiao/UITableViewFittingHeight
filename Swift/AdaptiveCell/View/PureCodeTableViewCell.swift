//
//  PureCodeTableViewCell.swift
//  AdaptiveCell
//
//  Created by Yongxiang Miao on 2019/3/31.
//  Copyright © 2019 com.smilingmiao.code. All rights reserved.
//

import UIKit
import SnapKit

class PureCodeTableViewCell: UITableViewCell {
  
  private final var titleLabel: UILabel!
  private final var contentLabel: UILabel!

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    initializeUI()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindData(current feed: FeedItem) {
    titleLabel.text = feed.title
    contentLabel.text = feed.content
  }
  
  private final func initializeUI() {
    
    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
    contentView.addSubview(titleLabel)
    
    contentLabel = UILabel()
    contentLabel.numberOfLines = 0
    contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .thin)
    contentView.addSubview(contentLabel)
  }
  
  private final func setupLayout() {
//    layoutWithMasonry()
    layoutWithNative()
  }
  
  private final func layoutWithMasonry() {
    
    titleLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(contentView.snp_top).offset(20)
      make.leading.equalTo(contentView.snp_leading).offset(10)
      make.trailing.equalTo(contentView.snp_trailing).offset(-10)
    }
    
    contentLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(titleLabel.snp_bottom).offset(10)
      make.leading.equalTo(titleLabel.snp_leading).offset(0)
      make.trailing.equalTo(titleLabel.snp_trailing).offset(0)
      make.bottom.equalTo(contentView.snp_bottom).offset(-10)
    }
  }
  
  private final func layoutWithNative() {
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    let constraints1 = [
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
    ]
    contentView.addConstraints(constraints1)
    
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    let constraints2 = [
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
      contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
      contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ]
    contentView.addConstraints(constraints2)
  }
  
}
