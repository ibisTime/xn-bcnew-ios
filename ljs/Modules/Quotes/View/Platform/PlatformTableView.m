//
//  PlatformTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformTableView.h"
//V
#import "PlatformAllCell.h"
#import "PlatformPriceCell.h"
#import "PlatformCell.h"

@interface PlatformTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PlatformTableView

static NSString *platformAllCell = @"PlatformAllCell";
static NSString *platformPriceCell = @"PlatformPriceCell";
static NSString *platformCell = @"PlatformCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //全部平台
        [self registerClass:[PlatformAllCell class] forCellReuseIdentifier:platformAllCell];
        //资金
        [self registerClass:[PlatformPriceCell class] forCellReuseIdentifier:platformPriceCell];
        //具体平台
        [self registerClass:[PlatformCell class] forCellReuseIdentifier:platformCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatformModel *platform = self.platforms[indexPath.row];
    
    if (self.type == PlatformTypeAll) {
        
        PlatformAllCell *cell = [tableView dequeueReusableCellWithIdentifier:platformAllCell forIndexPath:indexPath];
        
        cell.platform = platform;
        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

        return cell;
        
    } else if (self.type == PlatformTypeMoney) {
        
        PlatformPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:platformPriceCell forIndexPath:indexPath];
        
        cell.platform = platform;
        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

        return cell;
    }
    
    PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];
    
    cell.platform = platform;
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlatformModel *platform = self.platforms[indexPath.row];
    self.selectBlock(platform.ID);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
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
