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
    
    cell.isAll = self.isAll;
    NewsFlashModel *new = self.news[indexPath.section];
    
    new.isShowDate = [self isShowDateWithIndexPath:indexPath.section];
    
    cell.flashModel = new;
    cell.shareBtn.tag = 2000 + indexPath.section;
    
    [cell.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL)isShowDateWithIndexPath:(NSInteger )indexPath {
    
    //第一个直接
    if (indexPath == 0) {
        
        return NO;
    }
    //后面的时间跟前面比对
    NewsFlashModel *new1 = self.news[indexPath - 1];
    NewsFlashModel *new2 = self.news[indexPath];
    
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
    
    if (![self isShowDateWithIndexPath:section]) {
        return 30;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headrSectionview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headrSectionview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F7"];
    
    UILabel *titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:[UIColor colorWithHexString:@"#002A00"] font:14];
    [headrSectionview addSubview:titleLable];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    NewsFlashModel *new = self.news[section];
    NSString *month = [new.showDatetime convertDateWithFormat:@"MM月dd日"];
    
   
    
    NSString *WeekStr = [self getWeekDayFordate:new.showDatetime];
    
    titleLable.text = [NSString stringWithFormat:@"%@%@",month,WeekStr];
    
    return headrSectionview;
}
- (NSString *)getWeekDayFordate:(NSString *)dateStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
//    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSDate *newDate = [formatter dateFromString:dateStr];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
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
