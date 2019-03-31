//
//  AdaptiveTableViewCell.m
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import "AdaptiveTableViewCell.h"

@interface AdaptiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AdaptiveTableViewCell

- (void)setFeed:(Feed *)feed
{
  _feed = feed;
  
  self.titleLabel.text = feed.titleName;
  self.contentLabel.text = feed.feedContent;
}

@end
