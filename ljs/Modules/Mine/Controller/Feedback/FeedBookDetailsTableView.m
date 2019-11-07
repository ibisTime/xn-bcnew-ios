//
//  FeedBookDetailsTableView.m
//  Coin
//
//  Created by 郑勤宝 on 2019/5/20.
//  Copyright © 2019 chengdai. All rights reserved.
//

#import "FeedBookDetailsTableView.h"

#import "FeedBookDetailsCell.h"
@interface FeedBookDetailsTableView()<UITableViewDelegate, UITableViewDataSource>


@end
@implementation FeedBookDetailsTableView

static NSString *identifierCell = @"FeedBookDetailsCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        //        [self setContentInset:UIEdgeInsetsMake(5, 0.0, -5, 0.0)];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self registerClass:[FeedBookDetailsCell class] forCellReuseIdentifier:identifierCell];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell theme_setBackgroundColorIdentifier:BackColor moduleName:ColorName];
        cell.backgroundColor = kWhiteColor;
        NSArray *arr = [self.questionModel.pic componentsSeparatedByString:@"||"];
        if (arr.count > 0) {
            for (int i = 0; i < arr.count; i ++) {
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15 + i % 4 * (SCREEN_WIDTH - 30)/4, 10 + i / 4 * (SCREEN_WIDTH - 30)/4, (SCREEN_WIDTH - 30 - 30)/4, (SCREEN_WIDTH - 30 - 30)/4)];
                [img sd_setImageWithURL:[NSURL URLWithString:[arr[i] convertImageUrl]]];
                kViewRadius(img , 4);
                [cell addSubview:img];
            }
        }
        return cell;
    }
    
    FeedBookDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array = @[@"所在端",@"问题描述",@"",@"提交时间",@"bug状态"];
    cell.nameLbl.text = array[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailsLbl.text = self.questionModel.deviceSystem;
    }
    if (indexPath.row == 1) {
        cell.detailsLbl.text = self.questionModel.Description;
    }
//    if (indexPath.row == 3) {
//        cell.detailsLbl.text = self.questionModel.commitNote;
//    }
    if (indexPath.row == 3) {
        cell.detailsLbl.text = [self.questionModel.commitDatetime convertDate];
    }
    if (indexPath.row == 4) {
        if ([self.questionModel.status isEqualToString:@"0"]) {
            cell.detailsLbl.text = @"待审核";
        }else if ([self.questionModel.status isEqualToString:@"1"])
        {
            cell.detailsLbl.text = @"处理中";
        }else if ([self.questionModel.status isEqualToString:@"2"])
        {
            cell.detailsLbl.text = @"复现不成功";
        }else
        {
            cell.detailsLbl.text = @"已处理";
        }
    }
    cell.nameLbl.frame = CGRectMake(15, 0, 90, 70);
    [cell.nameLbl sizeToFit];
    cell.nameLbl.frame = CGRectMake(15, 0, cell.nameLbl.width, 70);
    cell.detailsLbl.frame = CGRectMake(cell.nameLbl.xx + 10, 0, SCREEN_WIDTH - cell.nameLbl.xx - 10, 70);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        NSArray *arr = [self.questionModel.pic componentsSeparatedByString:@"||"];
        if (arr.count > 0) {
            float numberToRound;
            int result;
            numberToRound = (arr.count)/4.0;
            result = (int)ceilf(numberToRound);
            return result * (SCREEN_WIDTH - 30)/4 + 10;
        }else
        {
            return 0;
        }
        
    }
//    if (indexPath.row == 2) {
//        if ([self.questionModel.status isEqualToString:@"3"]) {
//            return 0;
//        }else
//        {
//            return 70;
//        }
//    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
