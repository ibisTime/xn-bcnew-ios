//
//  CircleCommentVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CircleCommentVC.h"
//V
#import "TopLabelUtil.h"

@interface CircleCommentVC ()<SegmentDelegate>
//
@property (nonatomic, strong) TopLabelUtil *labelUnil;
@property (nonatomic, strong) UIScrollView *switchSV;
//titles
@property (nonatomic, strong) NSArray *titles;

@end

@implementation CircleCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initSubviews];
    //添加子控制器
    [self addChildVC];
}

#pragma mark - Init
- (void)initSubviews {
    
    self.titles = @[
                    @"回复我的",
                    @"我的评论"
                    ];
    //0.顶部切换
    CGFloat h = 34;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    self.labelUnil.delegate = self;
//    self.labelUnil.backgroundColor = [UIColor clearColor];
//    self.labelUnil.titleNormalColor = kWhiteColor;
//    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.layer.borderColor = kLineColor.CGColor;
    self.labelUnil.titleFont = Font(18.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = self.titles;
    self.navigationItem.titleView = self.labelUnil;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(self.titles.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    
}

- (void)addChildVC {
    
    NSArray *typeList = @[
                          @"0",
                          @"1",
                          ];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        CircleCommentChildVC *childVC = [[CircleCommentChildVC alloc] init];
        
        childVC.type = typeList[i];
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [self.switchSV addSubview:childVC.view];
    }
    
}

#pragma mark - SegmentDelegate, 顶部切换
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
