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

@property (nonatomic, weak) UITextField *bookTextField;
@property (nonatomic, weak) UITextField *summaryTextField;
@property (nonatomic, weak) UIAlertAction *confirmAction;

@end

@implementation ViewController

static NSString * const cellID = @"adaptiveCell";

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Books";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFeedsChange:)
                                                 name:kFeedsChangedNotificationName
                                               object:nil];
    
    [self.view addSubview:self.tableView];

    /// 注册 xib 还是纯代码，其中纯代码又分用 Masonry 和用 iOS 自带 AutoLayout，这个需要在 `PureCodeTableViewCell` 中设置。
    [self registerWithXib:YES];
    
    self.feedHolder = [[FeedHolder alloc] init];
    [self.feedHolder buildData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor]];
    [self.view addConstraint:[self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]];
    [self.view addConstraint:[self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]];
    [self.view addConstraint:[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-35]];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"增加条目" message:@"填写书名和简介" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写书名";
        [textField addTarget:self action:@selector(inputText:) forControlEvents:UIControlEventEditingChanged];
        self.bookTextField = textField;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写简介";
        [textField addTarget:self action:@selector(inputText:) forControlEvents:UIControlEventEditingChanged];
        self.summaryTextField = textField;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    self.confirmAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dict = @{@"title": self.bookTextField.text,
                               @"content": self.summaryTextField.text};
        Feed *feed = [[Feed alloc] initWithDictionary:dict];
        [self.feedHolder addFeed:feed atIndex:0];
    }];
    [self.confirmAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    self.confirmAction.enabled = NO;
    [alert addAction:self.confirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)inputText:(UITextField *)textField
{
    if (self.bookTextField.text.length > 0 && self.summaryTextField.text.length > 0) {
        self.confirmAction.enabled = YES;
    } else {
        self.confirmAction.enabled = NO;
    }
}

- (void)deleteAtIndex:(NSUInteger)index
{
    if (self.feedHolder.count > index) {
        [self.feedHolder removeAtIndex:index];
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
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
        }
        case deleteRow: {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:behavior.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.feedHolder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_isUseXib) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        [(AdaptiveTableViewCell *)cell setFeed:[self.feedHolder feed:indexPath.row]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[PureCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [(PureCodeTableViewCell *)cell bindData:[self.feedHolder feed:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteAtIndex:indexPath.row];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

#pragma mark - getter & setter
- (UITableView *)tableView
{
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
