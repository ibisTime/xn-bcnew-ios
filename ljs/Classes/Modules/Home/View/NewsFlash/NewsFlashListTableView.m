//
//  NewsFlashListTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashListTableView.h"
//Category
#import "NSString+Date.h"
//V
#import "NewsFlashListCell.h"

@interface NewsFlashListTableView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NewsFlashListTableView

static NSString *identifierCell = @"NewsFlashListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[NewsFlashListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.news.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFlashListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    NewsFlashModel *new = self.news[indexPath.section];
    
    new.isShowDate = [self isShowDateWithIndexPath:indexPath];
    
    cell.flashModel = new;
    cell.shareBtn.tag = 2000 + indexPath.section;
    
    [cell.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL)isShowDateWithIndexPath:(NSIndexPath *)indexPath {
    
    //第一个直接
    if (indexPath.section == 0) {
        
        return NO;
    }
    //后面的时间跟前面比对
    NewsFlashModel *new1 = self.news[indexPath.section - 1];
    NewsFlashModel *new2 = self.news[indexPath.section];
    
    NSString *day1 = [new1.showDatetime convertDateWithFormat:@"d"];
    NSString *day2 = [new2.showDatetime convertDateWithFormat:@"d"];
    
    if ([day1 integerValue] == [day2 integerValue]) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NewsFlashModel *flashModel = self.news[indexPath.section];
    
    flashModel.isSelect = !flashModel.isSelect;

    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.news[indexPath.section].cellHeight;
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

#pragma mark - Events
- (void)clickShare:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2000;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

@end
