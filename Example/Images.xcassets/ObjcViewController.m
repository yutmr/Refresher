//
//  ObjcViewController.m
//  Example
//
//  Created by Yu Tamura on 2017/10/07.
//  Copyright © 2017 Yu Tamura. All rights reserved.
//

#import "ObjcViewController.h"
#import "Example-Swift.h"

@interface ObjcViewController ()<RefresherDelegate>

@property(nonatomic, retain) Refresher *refresher;

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *refresherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    _refresher = [[Refresher alloc] initWithRefreshView:refresherView scrollView:self.tableView];
    _refresher.animateDuration = 1;
    _refresher.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - Refresher delegate

- (void)updateRefreshViewWithRefreshView:(UIView *)refreshView state:(enum RefreshState)state percent:(float)percent {
    switch (state) {
        case RefreshStateStable:
            if (percent > 1) {
                percent = 1;
            } else if (percent < 0) {
                percent = 0;
            }
            refreshView.backgroundColor = [[UIColor alloc] initWithRed:percent green:0 blue:0 alpha:1];
            break;
        case RefreshStateReady:
            refreshView.backgroundColor = [UIColor blueColor];
            break;
        case RefreshStateRefreshing:
            refreshView.backgroundColor = [UIColor yellowColor];
            break;
    }
}

- (void)startRefreshing {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.refresher finishRefreshing];
    });
}

@end
