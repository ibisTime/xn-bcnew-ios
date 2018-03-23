//
//  InputTextView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InputTextView.h"

//Macro
//Framework
//Category
#import "TLAlert.h"
//Extension
//M
//V
//C

#define DEFAULT_HEIGHT (205)

@interface InputTextView()<UITextViewDelegate>
//是否展示
@property (nonatomic, assign) BOOL isKeyboardShow;
//是否第三方键盘
@property (nonatomic, assign) BOOL isThirdPartKeyboard;
//键盘弹出时间
@property (nonatomic, assign) NSInteger keyboardShowTime;
//背景
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGFloat defaultConstraint;
@property (nonatomic, assign) CGFloat keyboardAnimateDur;
@property (nonatomic) CGPoint oldOffset;
@property (nonatomic) CGRect keyboardFrame;

@end

@implementation InputTextView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self initKeyboardObserver];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, DEFAULT_HEIGHT)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bgView];
    
    CGFloat btnH = 40;
    //取消
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消"
                                         titleColor:kTextColor
                                    backgroundColor:kClearColor
                                          titleFont:14.0];
    
    [cancelBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 65, btnH);

    [self.bgView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    //发布
    UIButton *sureBtn = [UIButton buttonWithTitle:@"发布"
                                         titleColor:kTextColor
                                    backgroundColor:kClearColor
                                          titleFont:14.0];
    
    [sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(kScreenWidth - 65, 0, 65, btnH);
    
    [self.bgView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kHexColor(@"#E2E2E2");
    
    [self.bgView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@40);
        make.height.equalTo(@0.5);
    }];
    
    //输入框
    self.commentTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sureBtn.frame) + 0.5, kScreenWidth, 150)];
    
    self.commentTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.commentTV.placeholderLbl.font = Font(13.0);
    self.commentTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.commentTV.placholder = @"说出你的看法";
    
    [self.bgView addSubview:self.commentTV];
    
    [self initKeyboardObserver];
}

#pragma mark - Events
- (void)cancle:(UIButton *)sender {
    
    [self.delegate clickedCancelBtn];
    
    [self dismiss];
}

- (void)sureBtn:(UIButton *)sender {
    
    if (self.commentTV.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请输入评论内容"];
        return ;
    }
    
    [self.delegate clickedSureBtnWithText:self.commentTV.text];
    
    [self dismiss];
}

- (void)show {
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [self.commentTV becomeFirstResponder];
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

#pragma mark - 键盘事件
- (void)initKeyboardObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSValue* keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardBoundsValue CGRectValue];
    
    NSNumber* keyboardAnimationDur = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float animationDur = [keyboardAnimationDur floatValue];
    
    _keyboardShowTime++;
    
    // 第三方输入法有bug,第一次弹出没有keyboardRect
    if (animationDur > 0.0f && keyboardRect.size.height == 0)
    {
        _isThirdPartKeyboard = YES;
    }
    
    // 第三方输入法,有动画间隔时,没有高度
    if (_isThirdPartKeyboard)
    {
        // 第三次调用keyboardWillShow的时候 键盘完全展开
        if (_keyboardShowTime == 3 && keyboardRect.size.height != 0 && keyboardRect.origin.y != 0)
        {
            _keyboardFrame = keyboardRect;
            
            NSLog(@"_keyboardFrame.size.height--%f",_keyboardFrame.size.height);
            //Animate change
            [UIView animateWithDuration:_keyboardAnimateDur animations:^{
                
//                self.bgView.frame = CGRectMake(0,kScreenHeight- _keyboardFrame.size.height-DEFAULT_HEIGHT, kScreenWidth, DEFAULT_HEIGHT);
                self.bgView.transform = CGAffineTransformMakeTranslation(0, - _keyboardFrame.size.height-DEFAULT_HEIGHT);

                [self layoutIfNeeded];
                [self layoutSubviews];
            }];
            
        }
        if (animationDur > 0.0) {
            
            _keyboardAnimateDur = animationDur;
        }
    }else {
        
        if (animationDur > 0.0)
        {
            _keyboardFrame = keyboardRect;
            _keyboardAnimateDur = animationDur;
            
            //Animate change
            [UIView animateWithDuration:_keyboardAnimateDur animations:^{
                
                self.bgView.transform = CGAffineTransformMakeTranslation(0, - _keyboardFrame.size.height-DEFAULT_HEIGHT);
                
                [self layoutIfNeeded];
                [self layoutSubviews];
            }];
        }
    }
}

- (void)keyboardDidShow:(NSNotification*)notification
{
    _isKeyboardShow = YES;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSNumber* keyboardAnimationDur = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float animationDur = [keyboardAnimationDur floatValue];
    
    _isThirdPartKeyboard = NO;
    _keyboardShowTime = 0;
    
    if (animationDur > 0.0) {
        
        [UIView animateWithDuration:_keyboardAnimateDur animations:^{
            
            self.bgView.transform = CGAffineTransformIdentity;
            
            [self layoutIfNeeded];
            [self layoutSubviews];
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
}

- (void)keyboardDidHide:(NSNotification*)notification {
    
    _isKeyboardShow = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.commentTV.text.length > 0) {
        
        [self.sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else {
        
        [self.sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
