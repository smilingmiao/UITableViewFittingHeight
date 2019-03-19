//
//  Feed.h
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Feed : NSObject

@property (nonatomic, copy, readonly) NSString *titleName;
@property (nonatomic, copy, readonly) NSString *feedContent;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
