//
//  FillInRegistrationFormVC.m
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "FillInRegistrationFormVC.h"

@interface FillInRegistrationFormVC ()

@end

@implementation FillInRegistrationFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写报名表";

    [self initRightBarBut];
    
    
    

    
    
}
-(void)initRightBarBut
{
    UIBarButtonItem * rightBar= [[UIBarButtonItem alloc]initWithTitle:@"报名" style:UIBarButtonItemStyleDone target:self action:@selector(signUp)];
    rightBar.tintColor = kWhiteColor;
    self.navigationItem.rightBarButtonItem= rightBar;
}


-(void)signUp
{
    NSLog(@"报名");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
