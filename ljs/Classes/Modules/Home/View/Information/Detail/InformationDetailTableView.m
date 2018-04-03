//
//  InformationDetailTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationDetailTableView.h"
//V
#import "InfoCommentCell.h"
#import "InformationListCell.h"

@interface InformationDetailTableView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation InformationDetailTableView

static NSString *infoCommentCellID = @"InfoCommentCell";
static NSString *informationListCellID = @"InformationListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[InfoCommentCell class] forCellReuseIdentifier:infoCommentCellID];
        [self registerClass:[InformationListCell class] forCellReuseIdentifier:informationListCellID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.detailModel.refNewList.count;
        
    } else if (section == 1) {
        
        return self.detailModel.hotCommentList.count;
    }
    
    return self.newestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    //分区0 相关文章
    if (indexPath.section == 0) {
        
        InformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:informationListCellID forIndexPath:indexPath];
        
        cell.infoModel = self.detailModel.refNewList[indexPath.row];
        
        return cell;
    }
    //分区1热门评论 分区2最新评论
    InfoCommentModel *commentModel = indexPath.section == 1 ? self.detailModel.hotCommentList[indexPath.row]: self.newestComments[indexPath.row];
    
    InfoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCommentCellID forIndexPath:indexPath];
    
    cell.zanBtn.tag = 1300 + indexPath.row + 1000*indexPath.section;
    
    [cell.zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentModel = commentModel;
    
    __block NSIndexPath *idxPath = indexPath;
    
    cell.clickReplyBlock = ^(NSInteger index) {
        
        if (weakSelf.refreshDelegate && [weakSelf.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
            
            [weakSelf.refreshDelegate refreshTableView:weakSelf didSelectRowAtIndexPath:idxPath];
        }
    };
    
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
        
        return 130;
        
    } else if (indexPath.section == 1) {
        
        height = self.detailModel.hotCommentList[indexPath.row].cellHeight;
        
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
        
        if (self.detailModel.refNewList.count == 0) {
            
            return 0.1;
        }
    } else if (section == 1) {
        
        if (self.detailModel.hotCommentList.count == 0) {
            
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
        
        if (self.detailModel.refNewList.count == 0) {
            
            return [UIView new];
        }
    } else if (section == 1) {
        
        if (self.detailModel.hotCommentList.count == 0) {
            
            return [UIView new];
        }
    } else if (section == 2) {
        
        if (self.newestComments.count == 0) {
            
            return [UIView new];
        }
    }
    
    NSArray *titleArr = @[@"相关文章", @"热门评论", @"最新评论"];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];

    headerView.backgroundColor = kWhiteColor;

    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kBlueLineColor;
    
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

@end
