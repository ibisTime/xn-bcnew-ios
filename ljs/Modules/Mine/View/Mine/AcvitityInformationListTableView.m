//
//  AcvitityInformationListTableView.m
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AcvitityInformationListTableView.h"
#import "InformationListCell.h"
#import "InformationListCell2.h"
#import "ActivityListTakeCell.h"
#import <MJExtension/MJExtension.h>
@interface AcvitityInformationListTableView()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation AcvitityInformationListTableView

static NSString *informationListCell = @"ActivityListTakeCell";
static NSString *informationListCell2 = @"InformationListCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ActivityListTakeCell class] forCellReuseIdentifier:informationListCell];
        [self registerClass:[InformationListCell2 class] forCellReuseIdentifier:informationListCell2];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityListModel *info = (ActivityListModel *)self.infos[indexPath.row];
    
    ActivityDetailModel *detalModel = [ActivityDetailModel mj_objectWithKeyValues:info.activity];
    
        ActivityListTakeCell *cell = [tableView dequeueReusableCellWithIdentifier:informationListCell forIndexPath:indexPath];
        //shuju
        cell.infoModel = detalModel;
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
    
//    ActivityDetailModel *info = (ActivityDetailModel *)self.infos[indexPath.row];
    
   
        return 125;
   
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
