//
//  UserEditCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
//V
#import "BaseTableViewCell.h"

@interface UserEditCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIView *lineView;

@end
