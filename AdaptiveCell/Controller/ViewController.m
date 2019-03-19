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
#import "Feed.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
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
    
    [self loadData:^{
        [self.tableView reloadData];
    }];
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
- (void)loadData:(void (^)(void))then
{
    NSArray *data = @[@{@"title": @"最好的告别",
                        @"content": @"当独立、自助的生活不能再维持时，我们该怎么办？在生命临近终点的时刻，我们该和医生谈些什么？应该如何优雅地跨越生命的终点？对于这些问题，大多数人缺少清晰的观念，而只是把命运交由医学、技术和陌生人来掌控。影响世界的医生阿图•葛文德结合其多年的外科医生经验与流畅的文笔，讲述了一个个伤感而发人深省的故事，对在21世纪变老意味着什么进行了清醒、深入的探索。本书富有洞见、感人至深，并为我们提供了实用的路线图，告诉我们为了使生命最后的岁月有意义，我们可以做什么、应该做什么。作者选择了常人往往不愿面对的话题——衰老与死亡，梳理了美国社会养老的方方面面和发展历程，以及医学界对末期病人的不当处置。书中不只讲述了死亡和医药的局限，也揭示了如何自主、快乐、拥有尊严地活到生命的终点。书中对“善终服务”“辅助生活”“生前预嘱”等一系列作者推崇的理念，都穿插在故事中作出了详尽的..."},
                      @{@"title": @"黑天鹅 Black Swan",
                        @"content": @"纽约剧团要重排《天鹅湖》，因前领舞Beth（薇诺娜•赖德 Winona Ryder 饰）离去，总监Thomas（文森特•卡索尔 Vincent Cassel. 饰）决定海选新领舞，且要求领舞要分饰黑天鹅与白天鹅。Nina（娜塔莉•波特曼Natalie Portman 饰）自幼练习芭蕾舞，在母亲的细心关照下，技艺出众。这次，她希望可以脱颖而出。然而，在竞争中，她发现心机颇重的Lily（米拉•库妮丝 Mila Kunis 饰）是自己的强劲对手。在选拔中，她的白天鹅表演的无可挑剔，但是黑天鹅不及Lily。她感到身心俱疲，回家还发现了背部的红斑与脚伤。她一个人找到总监，希望争取一下。总监趁机亲吻她，却被她强硬拒绝。结果，总监居然选了她。队友怀疑她靠色相上位。在酒会上，Beth甚至当众发泄。这种压力外加伤病，一直影响着她的发挥。总监启发她要释放激情，表现出黑天..."},
                      @{@"title": @"原则",
                        @"content": @"※ 华尔街投资大神、对冲基金公司桥水创始人，人生经验之作\n作者瑞·达利欧出身美国普通中产家庭，26岁时被炒鱿鱼后在自己的两居室内创办了桥水，现在桥水管理资金超过1 500亿美元，截至2015年年底，盈利超过450亿美元。达利欧曾成功预测2008年金融危机，现在将其白手起 家以来40多年的生活和工作原则公开。\n※ 多角度、立体阐述生活、工作、管理原则\n包含21条高原则、139条中原则和365条分原则，涵盖为人处事、公司管理两大方面。此前从未有过的逐一详细解答，配合达利欧多年来的各种实例和感悟。任何人都可以轻松上手实践。用以指导桥水日常管理，是桥水的员工手册，帮助桥水屹立40余年不倒，经受住了现实考验。\n※ 半个金融圈、投资界、管理层都在期待简体中文版\n2010年起，简略版的原则被放在桥水官网上，至今共计被下载了超过300万次，无数企业、管理者、职场人士..."}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *entities = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [entities addObject:[[Feed alloc] initWithDictionary:(NSDictionary *)obj]];
        }];
        [self.dataSource addObjectsFromArray:entities];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (then) {
                then();
            }
        });
    });
}

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

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_isUseXib) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        [(AdaptiveTableViewCell *)cell setFeed:self.dataSource[indexPath.row]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[PureCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [(PureCodeTableViewCell *)cell bindData:self.dataSource[indexPath.row]];
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

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
