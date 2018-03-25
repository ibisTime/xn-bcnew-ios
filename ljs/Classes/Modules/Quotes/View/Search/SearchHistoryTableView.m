//
//  SearchHistoryTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchHistoryTableView.h"
//V
#import "SearchHistoryCell.h"

@interface SearchHistoryTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchHistoryTableView

static NSString *identifierCell = @"SearchHistoryCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[SearchHistoryCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.historyRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.contentLbl.text = self.historyRecords[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSArray *myarray = [[NSUserDefaults standardUserDefaults]arrayForKey:@"HistorySearch"];

    if (myarray.count == 0) {
        
        return [UIView new];
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //清除搜索历史
    UIButton *clearHistoryBtn = [UIButton buttonWithTitle:@"清除搜索历史"
                                               titleColor:kTextColor
                                          backgroundColor:kClearColor
                                                titleFont:13.0];
    
    [clearHistoryBtn setImage:kImage(@"清除") forState:UIControlStateNormal];
    [clearHistoryBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [clearHistoryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [footerView addSubview:clearHistoryBtn];
    [clearHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
        make.centerY.equalTo(@0);
    }];
    
    return footerView;
}

/**
 清除历史搜索
 */
- (void)clearHistory {
    
    NSArray *historyArr = @[];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    
    [mydefaults synchronize];
    
    self.historyRecords = historyArr;
    
    [self reloadData];
    
    self.tableFooterView = self.placeHolderView;

    [self reloadData];

}

@end
