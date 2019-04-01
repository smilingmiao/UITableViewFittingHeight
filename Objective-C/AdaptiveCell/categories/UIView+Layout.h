//
//  UIView+Layout.h
//
//  Created by Yongxiang Miao on 2019/1/20.
//  Copyright © 2019 Yongxiang Miao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_EQUAL_TO(v) ([[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_EQUAL_OR_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_EQUAL_OR_LESS_THAN(v) ([[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR (SCREEN_HEIGHT - ([UIApplication sharedApplication].statusBarFrame.size.height))

typedef CGFloat UIScreenHeightType;
static UIScreenHeightType UIScreenHeightType_iPhone4 = 480;
static UIScreenHeightType UIScreenHeightType_iPhone5 = 568;
static UIScreenHeightType UIScreenHeightType_iPhone6 = 667;
static UIScreenHeightType UIScreenHeightType_iPhone_Plus = 736;
static UIScreenHeightType UIScreenHeightType_iPhoneX = 812;
static UIScreenHeightType UIScreenHeightType_iPhoneXR = 896;
static UIScreenHeightType UIScreenHeightType_iPhoneXS_Max = 896;

@interface UIView (Layout)

- (void)fill;
- (void)fillInsetsBar;
- (void)topInset:(CGFloat)top inContainer:(nullable UIView *)container;

- (CGFloat)statusBarHeight;
- (CGFloat)navBarHeight;
- (CGFloat)tabBarHeight;
// tabBar minus tabBar button height
- (CGFloat)safeAreaBottomMargin;

- (CGFloat)contentHeight;
- (CGFloat)contentWithoutBarHeight;

// adapt notch screen
- (CGFloat)topGap;
- (CGFloat)leftGap;
- (CGFloat)bottomGap;
- (CGFloat)rightGap;

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGSize)size;
- (void)setSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
