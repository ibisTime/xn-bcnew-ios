//
//  ForumInfoTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumInfoTableView.h"
//V
#import "InformationListCell.h"
#import "InformationListCell2.h"

@interface ForumInfoTableView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ForumInfoTableView

static NSString *informationListCell = @"InformationListCell";
static NSString *informationListCell2 = @"InformationListCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[InformationListCell class] forCellReuseIdentifier:informationListCell];
        [self registerClass:[InformationListCell2 class] forCellReuseIdentifier:informationListCell2];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationModel *info = self.infos[indexPath.row];
    
    if (info.pics.count == 1) {
        
        InformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:informationListCell forIndexPath:indexPath];
        
        cell.infoModel = info;
        
        return cell;
    }
    
    InformationListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:informationListCell2 forIndexPath:indexPath];
    
    cell.infoModel = info;
    
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
    
    InformationModel *info = self.infos[indexPath.row];
    
    if (info.pics.count == 1) {
        
        return 130;
    }
    return info.cellHeight;
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

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (!self.vcCanScroll) {
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView偏移量为0）
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollOffset <= 0) {
        
        //偏移量小于等于零说明tableview到顶了
        self.vcCanScroll = NO;
        
        scrollView.contentOffset = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubVCLeaveTop" object:nil];
    }
}

//tableview和scrollView可以同时滚动,解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
