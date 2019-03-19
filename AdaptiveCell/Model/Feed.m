//
//  Feed.m
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _titleName = dict[@"title"];
        _feedContent = dict[@"content"];
    }
    return self;
}

@end
