//
//  PasswordView.m
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/25.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "PasswordView.h"

#import "UIColor+Extension.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define kPasswordLength 6
//textField中的竖线
#define kLineTag 1000
//textFiled中的星号显示
#define kDotTag 3000

#define textFieldWidth [UIScreen mainScreen].bounds.size.width - 30
#define textFieldHeight 32

@interface PasswordView ()<UITextFieldDelegate>

@end

@implementation PasswordView

//重写 init 方法
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        //初始化各种子控件
        
        self.inputTextFiled = [[LrdTextField alloc] init];
        self.inputTextFiled.backgroundColor = [UIColor whiteColor];

        self.inputTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#d1d1d1"].CGColor;
        self.inputTextFiled.layer.borderWidth = 1;
        self.inputTextFiled.secureTextEntry = YES;
        self.inputTextFiled.delegate = self;
        self.inputTextFiled.textAlignment = NSTextAlignmentCenter;
        
        self.inputTextFiled.font = [UIFont systemFontOfSize:26];
        self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        
        // edit by clk
        self.inputTextFiled.tintColor = [UIColor clearColor];
        self.inputTextFiled.textColor = [UIColor clearColor];
         self.inputTextFiled.pattern = [NSString stringWithFormat:@"^\\d{%li}$",(long)kPasswordLength - 1];
        [self.inputTextFiled addTarget:self action:@selector(textFiledEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.inputTextFiled];
        
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(textFieldHeight);
    }];
    
    // edit by clk
    [self textFieldAddSubview];
    
}

#pragma mark 监听textField的值改变事件

- (void)textFiledEditingChanged:(UITextField *)sender {
    
    NSInteger length = sender.text.length;
    
    for(int i = 0; i<kPasswordLength; i++){
        
        UILabel *dotLabel = (UILabel *)[self.inputTextFiled viewWithTag:kDotTag + i];
        
        if(dotLabel){
            
            dotLabel.hidden = length <= i;
        }
    }
    
    if (length == kPasswordLength) {
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [sender resignFirstResponder];
//        });
        
        if (_block) {
            
            _block(sender.text);
        }

    }
    
}

//密码错误
- (void)clearDotWithText:(NSString *)text {

    self.inputTextFiled.text = @"";
    
    NSInteger length = text.length;

    for(int i = 0; i<kPasswordLength; i++){
        
        UILabel *dotLabel = (UILabel *)[self.inputTextFiled viewWithTag:kDotTag + i];
        
        if(dotLabel){
            
            dotLabel.hidden = length <= i;
        }
    }
}
//添加竖线和星号
- (void)textFieldAddSubview {
    
//    CGFloat perWidth = (textFieldWidth - kPasswordLength + 1)*1.0/kPasswordLength;
    CGFloat perWidth = 32;
    for(NSInteger i = 0;i<kPasswordLength;i++){
        //画出分割线
        if(i < kPasswordLength - 1){
            UILabel *vLine = (UILabel *)[self.inputTextFiled viewWithTag:kLineTag + i];
            if(!vLine){
                vLine = [[UILabel alloc]init];
                vLine.tag = kLineTag + i;
                [self.inputTextFiled addSubview:vLine];
            }
            vLine.frame = CGRectMake((i+1)*perWidth, 0, 1, textFieldHeight);
            vLine.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"];
        }

        //星号输入
        UILabel *dotLabel = (UILabel *)[self.inputTextFiled viewWithTag:kDotTag + i];
        if(!dotLabel){
            dotLabel = [[UILabel alloc]init];
            dotLabel.tag = kDotTag + i;
            [self.inputTextFiled addSubview:dotLabel];
        }
        dotLabel.frame = CGRectMake( i*perWidth + (perWidth - 10)*0.5, (textFieldHeight - 10)*0.5, 10, 10);
        dotLabel.layer.masksToBounds = YES;
        dotLabel.layer.cornerRadius = 5;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

@end

#pragma mark LrdTextField的实现
@implementation LrdTextField

//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}

@end
