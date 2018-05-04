//
//  ActivityListV.m
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActivityListV.h"
#import "ActivityListCell.h"
#import "detailActivityVC.h"

//Category 响应者链
#import "UIView+Responder.h"

@interface ActivityListV () <UITableViewDataSource,UITableViewDelegate>

//v
@property (nonatomic, strong) ActivityListCell *cell;

@end

@implementation ActivityListV

static NSString *identifierCell = @"activityListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kClearColor;

        [self registerClass:[ActivityListCell class] forCellReuseIdentifier:identifierCell];
        
        
        //适配
        if (@available(iOS 11.0, *)) {
            
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.activities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     self.cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    
    activityModel *new = self.activities[indexPath.section];
    
    //    new.isShowDate = [self isShowDateWithIndexPath:indexPath];
    
    self.cell.actModel = new;
    
    return self.cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    detailActivityVC* detOfActVC = [[detailActivityVC alloc ] init ];
//    localMapManager *detOfActVC = [[localMapManager alloc] init];
        detOfActVC.code = self.cell.actModel.code;
    [self.viewController.navigationController pushViewController:detOfActVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    return self.news[indexPath.section].cellHeight;
    
#warning 变化
    return  307;
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

//#pragma mark - Events
//- (void)clickShare:(UIButton *)sender {
//
//    NSInteger index = sender.tag - 2000;
//
//    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
//
//        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
//    }
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
