//
//  PasswordView.h
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/25.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTReTextField.h"

typedef void (^successBlock)(NSString *text);

@interface LrdTextField : WTReTextField

@end

@interface PasswordView : UIView

//关闭或者密码输入完成时候调用的block
@property (nonatomic, strong) successBlock block;

//密码框
@property (nonatomic, strong) LrdTextField *inputTextFiled;

- (void)clearDotWithText:(NSString *)text;

@end


