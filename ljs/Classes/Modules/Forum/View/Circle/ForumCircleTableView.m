//
//  ForumCircleTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumCircleTableView.h"
//V
#import "ForumCircleCell.h"

@interface ForumCircleTableView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation ForumCircleTableView

static NSString *forumCircleCellID = @"ForumCircleCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ForumCircleCell class] forCellReuseIdentifier:forumCircleCellID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.detailModel.hotPostList.count;
    }
    
    return self.newestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //分区0热门评论 分区1最新评论
    ForumCommentModel *commentModel = indexPath.section == 0 ? self.detailModel.hotPostList[indexPath.row]: self.newestComments[indexPath.row];
    
    ForumCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:forumCircleCellID forIndexPath:indexPath];
    
    cell.zanBtn.tag = 1300 + indexPath.row + 1000*indexPath.section;
    
    [cell.zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentModel = commentModel;
    
    return cell;
}

- (void)clickZan:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1300;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height;
    
    if (indexPath.section == 0) {
        
        height = self.detailModel.hotPostList[indexPath.row].cellHeight;
        
        NSLog(@"height = %lf", height);
        return height;
    }
    
    height = self.newestComments[indexPath.row].cellHeight;
    NSLog(@"height = %lf", height);
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //判断是否有数据，没有就隐藏
    if (section == 0) {
        
        if (self.detailModel.hotPostList.count == 0) {
            
            return 0.1;
        }
    } else if (section == 2) {
        
        if (self.newestComments.count == 0) {
            
            return 0.1;
        }
    }
    
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //判断是否有数据，没有就隐藏
    if (section == 0) {
        
        if (self.detailModel.hotPostList.count == 0) {
            
            return [UIView new];
        }
    } else if (section == 1) {
        
        if (self.newestComments.count == 0) {
            
            return [UIView new];
        }
    }
    
    NSArray *titleArr = @[@"热门圈子", @"最新圈子"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    
    headerView.backgroundColor = kWhiteColor;
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [headerView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:17.0];
    textLbl.text = titleArr[section];
    [headerView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    
    return headerView;
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
