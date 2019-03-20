//
//  AdaptiveTableViewCell.h
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedHolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdaptiveTableViewCell : UITableViewCell

@property (nonatomic, copy) Feed *feed;

@end

NS_ASSUME_NONNULL_END
