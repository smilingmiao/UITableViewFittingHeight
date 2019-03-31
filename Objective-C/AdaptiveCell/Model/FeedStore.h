//
//  FeedHolder.h
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/20.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@class Behavior;

NS_ASSUME_NONNULL_BEGIN

@interface FeedStore : NSObject

- (instancetype)init;
+ (instancetype)new NS_UNAVAILABLE;

- (void)buildData;
@property (nonatomic, copy, readonly) NSMutableArray<Feed *> *feeds;

- (void)addFeed:(Feed *)feed atIndex:(NSUInteger)index;
- (void)removeAtIndex:(NSUInteger)index;
- (Feed *)feed:(NSInteger)atIndex;
- (NSUInteger)count;

@end


@interface Feed : NSObject

@property (nonatomic, copy, readonly) NSString *titleName;
@property (nonatomic, copy, readonly) NSString *feedContent;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

typedef NS_ENUM(NSUInteger, BehaviorType) {
    InsertRow,
    deleteRow,
    reloadRows
};

@interface Behavior : NSObject

@property (nonatomic, assign) BehaviorType behaviorType;
@property (nonatomic, assign) NSInteger index;
- (Behavior *)setBehaviorType:(BehaviorType)behaviorType atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
