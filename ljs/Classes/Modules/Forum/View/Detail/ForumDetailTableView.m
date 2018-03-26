//
//  ForumDetailTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailTableView.h"
//Category
#import "NSString+Check.h"
//M
#import "ForumDetailCell.h"

@interface ForumDetailTableView()<UITableViewDelegate, UITableViewDataSource>
//title
@property (nonatomic, strong) NSArray *titles;
//content
@property (nonatomic, strong) NSArray *contents;

@end

@implementation ForumDetailTableView

static NSString *identifierCell = @"ForumDetailCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ForumDetailCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

- (void)setDetailModel:(ForumDetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    self.titles = @[@"流通量", @"发行总量", @"流通市值", @"市值排名"];
    
    ForumDetailCoin *coin = _detailModel.coin;
    //流通量
    NSString *totalSupply = [coin.totalSupply valid] ? coin.totalSupply: @"- -";
    //发行总量
    NSString *maxSupply = [coin.maxSupply valid] ? coin.maxSupply: @"- -";
    //流通市值
    NSString *marketCap = [coin.maxSupply valid] ? coin.maxSupply: @"- -";
    //市值排名
    NSString *rank = [coin.rank valid] ? coin.rank: @"- -";
    
    self.contents = @[totalSupply, maxSupply, marketCap, rank];
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ForumDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

    cell.textLbl.text = self.titles[indexPath.row];
    cell.contentLbl.text = self.contents[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
