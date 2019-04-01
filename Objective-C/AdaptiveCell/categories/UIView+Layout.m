//
//  UIView+Layout.m
//
//  Created by Yongxiang Miao on 2019/1/20.
//  Copyright © 2019 Yongxiang Miao. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>

static void *kUIViewLayoutSafeAreaTopGap = &kUIViewLayoutSafeAreaTopGap;
static void *kUIViewLayoutSafeAreaLeftGap = &kUIViewLayoutSafeAreaLeftGap;
static void *kUIViewLayoutSafeAreaBottomGap = &kUIViewLayoutSafeAreaBottomGap;
static void *kUIViewLayoutSafeAreaRightGap = &kUIViewLayoutSafeAreaRightGap;

@implementation UIView (Layout)

- (void)fill {
    self.frame = CGRectMake(0, self.statusBarHeight, self.superview.frame.size.width, self.superview.frame.size.height);
}

- (void)fillInsetsBar {
    if (SCREEN_HEIGHT > UIScreenHeightType_iPhone_Plus) {
        self.frame = CGRectMake(self.superview.leftGap, self.navBarHeight, SCREEN_WIDTH - self.superview.leftGap - self.superview.rightGap, self.contentWithoutBarHeight);
    } else {
        self.frame = CGRectMake(0, self.navBarHeight, SCREEN_WIDTH, self.contentWithoutBarHeight);
    }
}

- (void)topInset:(CGFloat)top inContainer:(nullable UIView *)container {
    CGRect frame = CGRectZero;
    if (container == nil) {
        frame = self.superview.bounds;
    } else {
        frame = container.bounds;
    }
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGFloat)navBarHeight {
    CGFloat height = 0;
    if (SCREEN_HEIGHT < SCREEN_WIDTH) {
        height = 32;
    } else {
        if (SCREEN_HEIGHT > UIScreenHeightType_iPhone_Plus) {
            height = 88;
        } else {
            height = 64;
        }
    }
    return height;
}

- (CGFloat)tabBarHeight {
    CGFloat height = 0;
    if (SCREEN_HEIGHT < SCREEN_WIDTH) {
        if (SCREEN_WIDTH > UIScreenHeightType_iPhone_Plus) {
            height = 53;
        } else {
            height = 32;
        }
    } else {
        if (SCREEN_HEIGHT > UIScreenHeightType_iPhone_Plus) {
            height = 83;
        } else {
            height = 49;
        }
    }
    return height;
}

- (CGFloat)safeAreaBottomMargin {
    CGFloat height = 0;
    if (SCREEN_HEIGHT < SCREEN_WIDTH) {
        if (SCREEN_WIDTH > UIScreenHeightType_iPhone_Plus) {
            height = 22;
        }
    } else {
        if (SCREEN_HEIGHT > UIScreenHeightType_iPhone_Plus) {
            height = 35;
        }
    }
    return height;
}

- (CGFloat)contentHeight {
    return SCREEN_HEIGHT_WITHOUT_STATUS_BAR - self.safeAreaBottomMargin;
}

- (CGFloat)contentWithoutBarHeight {
    return SCREEN_HEIGHT - self.navBarHeight - self.tabBarHeight;
}

- (CGFloat)topGap {
    NSNumber *topGap = objc_getAssociatedObject(self, kUIViewLayoutSafeAreaTopGap);
    if (topGap == nil) {
        if (@available(iOS 11.0, *)) {
            topGap = @(self.superview.safeAreaLayoutGuide.layoutFrame.origin.y);
        } else {
            topGap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutSafeAreaTopGap, topGap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return topGap.floatValue;
}

- (CGFloat)leftGap {
    NSNumber *leftGap = objc_getAssociatedObject(self, kUIViewLayoutSafeAreaLeftGap);
    if (leftGap == nil) {
        if (@available(iOS 11.0, *)) {
            leftGap = @(self.superview.safeAreaLayoutGuide.layoutFrame.origin.x);
        } else {
            leftGap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutSafeAreaLeftGap, leftGap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return leftGap.floatValue;
}

- (CGFloat)bottomGap {
    NSNumber *bottomGap = objc_getAssociatedObject(self, kUIViewLayoutSafeAreaBottomGap);
    if (bottomGap == nil) {
        if (@available(iOS 11.0, *)) {
            bottomGap = @(self.superview.frame.size.height - self.superview.safeAreaLayoutGuide.layoutFrame.origin.y - self.superview.safeAreaLayoutGuide.layoutFrame.size.height);
        } else {
            bottomGap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutSafeAreaBottomGap, bottomGap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return bottomGap.floatValue;
}

- (CGFloat)rightGap {
    NSNumber *rightGap = objc_getAssociatedObject(self, kUIViewLayoutSafeAreaRightGap);
    if (rightGap == nil) {
        if (@available(iOS 11.0, *)) {
            rightGap = @(self.superview.safeAreaLayoutGuide.layoutFrame.origin.x);
        } else {
            rightGap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutSafeAreaBottomGap, rightGap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return rightGap.floatValue;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
