//
//  FeedHolder.m
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/20.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import "FeedHolder.h"
#import "CommonData.h"

@interface FeedHolder ()

@property (nonatomic, strong) Behavior *behavior;

@end

@implementation FeedHolder

- (instancetype)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _behavior = [Behavior new];
    _feeds = [NSMutableArray array];
    
    return self;
}

- (void)postWithBehavior:(Behavior *)behavior
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:behavior forKey:kFeedHolderDidChangeBehaviorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFeedsChangedNotificationName object:self userInfo:userInfo];
    });
}

- (void)buildData
{
    /// mock an asynchronously request behavior
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *file = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:file];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error != nil) {
            [NSException raise:@"数据解释出错" format:@"%@", @"数据结构可能有问题"];
        }
        
        NSArray *books = (NSArray *)[dict objectForKey:@"books"];
        [books enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            Feed *feed = [[Feed alloc] initWithDictionary:dict];
            [self.feeds addObject:feed];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self postWithBehavior:[self.behavior setBehaviorType:reloadRows atIndex:0]];
        });
    });
}

- (void)addFeed:(Feed *)feed atIndex:(NSUInteger)index
{
    [self.feeds insertObject:feed atIndex:index];
    [self postWithBehavior:[self.behavior setBehaviorType:InsertRow atIndex:index]];
}

- (void)removeAtIndex:(NSUInteger)index
{
    [self.feeds removeObjectAtIndex:index];
    [self postWithBehavior:[self.behavior setBehaviorType:deleteRow atIndex:index]];
}

- (Feed *)feed:(NSInteger)atIndex
{
    if (atIndex < self.count) {
        return self.feeds[atIndex];
    }
    return nil;
}

- (NSUInteger)count
{
    return self.feeds.count;
}

@end

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

@implementation Behavior

- (Behavior *)setBehaviorType:(BehaviorType)behaviorType atIndex:(NSUInteger)index
{
    self.behaviorType = behaviorType;
    self.index = index;
    
    return self;
}

@end
