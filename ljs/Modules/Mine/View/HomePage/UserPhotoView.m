//
//  UserPhotoView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "UserPhotoView.h"
//Category
#import "UIView+Responder.h"
//C
#import "HomePageInfoVC.h"
#import "HomePageCircleVC.h"
#import "NavigationController.h"

@implementation UserPhotoView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self addAction];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAction];
    }
    return self;
}


- (void)addAction {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserDetail)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
}

- (void)goUserDetail {
    
    
    if (!self.userId) {
        [TLAlert alertWithError:@"无 userId"];
        return;
    }
    
    if ([self.commentType isEqualToString:@"1"]) {
        
        HomePageInfoVC *pageVC = [[HomePageInfoVC alloc] init];
        
        pageVC.userId = self.userId;
        
        [self.viewController.navigationController pushViewController:pageVC animated:YES];
        return ;
    }
    
    HomePageCircleVC *pageVC = [[HomePageCircleVC alloc] init];
    
    pageVC.userId = self.userId;
    
    [self.viewController.navigationController pushViewController:pageVC animated:YES];
    return ;
}

@end
