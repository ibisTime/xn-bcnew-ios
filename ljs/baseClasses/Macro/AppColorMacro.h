//
//  AppColorMacro.h
//  YS_iOS
//
//  Created by 蔡卓越 on 17/1/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#ifndef AppColorMacro_h
#define AppColorMacro_h
#import "TLUser.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UILable+convience.h"
#import "UIView+Frame.h"
#import "UIButton+Custom.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#pragma mark - UIMacros

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// 主色
//#define kAppCustomMainColor [UIColor colorWithHexString:@"#2f93ed"]
#define kAppCustomMainColor [UIColor colorWithHexString:@"#022454"]

#define kMineBackGroundColor      [UIColor colorWithHexString:@"#f7f7f7"]
// 颜色配置
#define kNavBarMainColor  [UIColor appNavBarMainColor]
#define kNavBarBgColor    [UIColor appNavBarBgColor]


#define kTabbarMainColor   [UIColor appTabbarMainColor]
#define kTabbarBgColor     [UIColor appTabbarBgColor]
#define kHexColor(color) [UIColor colorWithHexString:color]

// 界面背景颜色
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//151, 215, 76 RGB(195, 207, 72)
#define kNavBarBackgroundColor  RGB(241, 241, 241)

#define kBackgroundColor        [UIColor colorWithHexString:@"#FAFCFF"]   //背景色
#define kLineColor              [UIColor colorWithHexString:@"#E2E2E2"]   //分割线
#define kBlueLineColor              [UIColor colorWithHexString:@"#FAFCFF"]   //蓝色分割线
#define kTextColor              [UIColor colorWithHexString:@"#3A3A3A"]   //一级文字
#define kTextColor2             [UIColor colorWithHexString:@"#818181"]   //二级文字
#define kTextColor3             [UIColor colorWithHexString:@"#666666"]   //三级文字
#define kTextColor4             [UIColor colorWithHexString:@"#b3b3b3"]   //四级文字
#define kThemeColor             [UIColor colorWithHexString:@"#f15353"]  //红色文字
#define kPaleBlueColor          [UIColor colorWithHexString:@"#48b0fb"]    //蓝色文字
#define kRiseColor              [UIColor colorWithHexString:@"#1FC07D"]  //涨
#define kbottomColor              [UIColor colorWithHexString:@"#FF5858"]  //涨

#define kStateColor              [UIColor colorWithHexString:@"#F6A623"]  //活动

#define kAuxiliaryTipColor      [UIColor colorWithHexString:@"#FF254C"]   //辅助提示颜色
#define kBottomItemGrayColor    [UIColor colorWithHexString:@"#FAFAFA"]   //底栏灰色
#define kCommentSecondColor     [UIColor colorWithHexString:@"#FAFAFA"]   //评论二级颜色
#define kPlaceholderColor       [UIColor colorWithHexString:@"#CCCCCC"]
    //占位颜色
#define kpigColor      [UIColor colorWithHexString:@"#FF5757"]

#define kClearColor [UIColor clearColor]           //透明
#define kWhiteColor RGB(255, 255, 255)             //白色   #ffffff
#define kBlackColor RGB(0, 0, 0)                   //黑色   #000000
#define kYellowColor [UIColor yellowColor]           //黄色
#define kBullowColor RGB(70, 86, 170)             //蓝色   #ffffff

#pragma mark - 界面尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define kWidth(x) (x)*(kScreenWidth)/375.0
#define kHeight(y) (y)*(kScreenHeight)/667.0

#define kDevice_Is_iPhoneX (kScreenHeight == 812 ? YES : NO)
#define kNavigationBarHeight  (kDevice_Is_iPhoneX == YES ? 88: 64)
#define kStatusBarHeight (kDevice_Is_iPhoneX == YES ? 44: 20)

#define kTabBarHeight  (49 + kBottomInsetHeight)
#define kBottomInsetHeight  (kDevice_Is_iPhoneX == YES ? 34: 0)
#define kSuperViewHeight    kScreenHeight - kNavigationBarHeight

#define kLeftMargin 15
#define kLineHeight 0.5

#define kImage(I)       [UIImage imageNamed:I]
#define kFontHeight(F)  [Font(F) lineHeight]

#define Font(F)         [UIFont systemFontOfSize:(F)]

#define boldFont(F)     [UIFont boldSystemFontOfSize:(F)]

#pragma mark - Image

#define USER_PLACEHOLDER_SMALL [UIImage imageNamed:@"默认头像"]
#define PLACEHOLDER_SMALL @"占位图"
#define kCancelIcon @"cancel"
#define GOOD_PLACEHOLDER_SMALL [UIImage imageNamed:@"占位图"]
#define APP_ICON @"app_icon"

#define kDateFormmatter @"MMM dd, yyyy hh:mm:ss aa"

#pragma mark - 轮播图

#define kCarouselHeight (kScreenWidth/5*3)

//View圆角和加边框

#define kViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
\
[View.layer setMasksToBounds:YES];\
\
[View.layer setBorderWidth:(Width)];\
\
[View.layer setBorderColor:[Color CGColor]]

// View圆角

#define kViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
\
[View.layer setMasksToBounds:YES]

#endif /* AppColorMacro_h */
