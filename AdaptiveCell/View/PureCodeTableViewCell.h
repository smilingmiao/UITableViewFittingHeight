//
//  PureCodeTableViewCell.h
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface PureCodeTableViewCell : UITableViewCell

- (void)bindData:(Feed *)feed;

@end

NS_ASSUME_NONNULL_END
