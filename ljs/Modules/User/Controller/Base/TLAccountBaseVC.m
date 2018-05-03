//
//  ZHAccountBaseVC.m
//  ljs
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountBaseVC.h"

@interface TLAccountBaseVC ()

@end

@implementation TLAccountBaseVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kBackgroundColor;
    self.bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgSV addGestureRecognizer:tap];
    [self.view addSubview:self.bgSV];

}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleDefault;
}

- (void)tap {

    [self.view endEditing:YES];
}

@end
