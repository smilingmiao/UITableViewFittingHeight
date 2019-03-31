//
//  PureCodeTableViewCell.m
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import "PureCodeTableViewCell.h"
#import "Masonry.h"

@interface PureCodeTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation PureCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self == nil) {
    return nil;
  }
  
  [self.contentView addSubview:self.titleLabel];
  [self.contentView addSubview:self.contentLabel];
  
    /// 使用 Masonry
    //    [self layoutWithMasonry];
    /// 使用 iOS 原生 AutoLayout
  [self layoutWithOriginal];
  
  return self;
}

#pragma mark - setup UI
- (void)layoutWithMasonry
{
  UIView *superview = self.contentView;
  
  [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(superview.mas_top).offset(20);
    make.leading.equalTo(superview.mas_leading).offset(10);
    make.trailing.equalTo(superview.mas_trailing).offset(-10);
  }];
  
  [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    make.leading.equalTo(self.titleLabel.mas_leading).offset(0);
    make.trailing.equalTo(self.titleLabel.mas_trailing).offset(0);
    make.bottom.equalTo(superview.mas_bottom).offset(-10);
  }];
}

- (void)layoutWithOriginal
{
  _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
    /// method1
    //    [self method1];
  
    /// method2
  [self method2];
}

- (void)method1
{
  UIView *superview = self.contentView;
  
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:20.0]];
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:10.0]];
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:-10.0]];
  
  
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_titleLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:10.0]];
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_titleLabel
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0 constant:0.0]];
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_titleLabel
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0.0]];
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:-10.0]];
  
}

- (void)method2
{
  UIView *superview = self.contentView;
  
    /// add constraints for titleLabel
  [superview addConstraint:[_titleLabel.topAnchor constraintEqualToAnchor:superview.topAnchor constant:20]];
  [superview addConstraint:[_titleLabel.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:10]];
  [superview addConstraint:[_titleLabel.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-10]];
  
    /// add constraints for contentLabel
  [superview addConstraint:[_contentLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:10]];
  [superview addConstraint:[_contentLabel.leadingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor constant:0]];
  [superview addConstraint:[_contentLabel.trailingAnchor constraintEqualToAnchor:_titleLabel.trailingAnchor constant:0]];
  [superview addConstraint:[_contentLabel.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-10]];
}

#pragma mark - fill data
- (void)bindData:(Feed *)data
{
  self.titleLabel.text = data.titleName;
  self.contentLabel.text = data.feedContent;
}

#pragma mark - getter

- (UILabel *)titleLabel
{
  if (_titleLabel == nil) {
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBlack];
  }
  return _titleLabel;
}

- (UILabel *)contentLabel
{
  if (_contentLabel == nil) {
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
  }
  return _contentLabel;
}

@end
