//
//  ViewController.m
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/18.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

#import "ViewController.h"
#import "AdaptiveTableViewCell.h"
#import "PureCodeTableViewCell.h"
#import "FeedHolder.h"
#import "CommonData.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FeedHolder *feedHolder;
@property (nonatomic, assign) BOOL isUseXib;

@end

@implementation ViewController

static NSString * const cellID = @"adaptiveCell";

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

    /// 注册 xib 还是纯代码，其中纯代码又分用 Masonry 和用 iOS 自带 AutoLayout，这个需要在 `PureCodeTableViewCell` 中设置。
    [self registerWithXib:NO];
    
    self.feedHolder = [[FeedHolder alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFeedsChange:)
                                                 name:kFeedsChangedNotificationName
                                               object:nil];
    
    [self.feedHolder buildData];
    
    self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addItem)],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                      target:self
                                                      action:@selector(delete)]
        ];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor]];
    [self.view addConstraint:[self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]];
    [self.view addConstraint:[self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]];
    [self.view addConstraint:[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
}

#pragma mark - private method
- (void)registerWithXib:(BOOL)isXib
{
    if (isXib) {
        UINib *nib = [UINib nibWithNibName:@"AdaptiveTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    } else {
        [self.tableView registerClass:[PureCodeTableViewCell class]
               forCellReuseIdentifier:cellID];
    }
    _isUseXib = isXib;
}

- (void)addItem
{
    if (self.feedHolder.feeds.count > 0) {
        Feed *feed = self.feedHolder.feeds.lastObject;
        [self.feedHolder addFeed:feed atIndex:1];
    }
}

- (void)delete
{
    if (self.feedHolder.feeds.count > 0) {
        [self.feedHolder removeAtIndex:0];
    }
}

- (void)handleFeedsChange:(NSNotification *)notification
{
    Behavior *behavior = (Behavior *)notification.userInfo[kFeedHolderDidChangeBehaviorKey];
    [self syncTableView:behavior];
}

- (void)syncTableView:(Behavior *)behavior
{
    switch (behavior.behaviorType) {
        case InsertRow: {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:behavior.index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case deleteRow: {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:behavior.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case reloadRows: {
            [self.tableView reloadData];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.feedHolder.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_isUseXib) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        [(AdaptiveTableViewCell *)cell setFeed:self.feedHolder.feeds[indexPath.row]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[PureCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [(PureCodeTableViewCell *)cell bindData:self.feedHolder.feeds[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = (id)self;
        _tableView.dataSource = (id)self;
        _tableView.estimatedRowHeight = 100;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}

@end
