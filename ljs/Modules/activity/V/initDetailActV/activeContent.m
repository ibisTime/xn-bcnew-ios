//
//  activeContent.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "activeContent.h"
#import "NSString+Extension.h"
@interface activeContent ()<UIWebViewDelegate>
@property (nonatomic, strong) UILabel *users;
@property (nonatomic, strong) UIWebView *userImg;

@property (nonatomic, strong) UIButton * moreButt;

@end
@implementation activeContent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = kWhiteColor;
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //1
    self.users = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    
    [self addSubview:self.users];
    [self.users mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(10);
        make.width.offset(kScreenWidth-20);
        make.height.offset(23);


    }];
    //2
//    self.userImg = [[UILabel alloc] init];
//    self.userImg.font = [UIFont systemFontOfSize:16];
//    [self addSubview:self.userImg];
//    self.userImg.textAlignment = NSTextAlignmentLeft;
//    self.userImg.numberOfLines = 0;
//    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.users.mas_bottom).offset(10);
//        make.right.offset(-15);
//
//        make.left.offset(15);
//        make.height.offset(kScreenHeight/2);
//
//
//    }];
    self.userImg = [[UIWebView alloc] init];
    self.userImg.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.userImg.scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addSubview:self.userImg];
    self.userImg.delegate = self;

        [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.users.mas_bottom).offset(10);
            make.right.offset(-15);
    
            make.left.offset(15);
            make.bottom.offset(0);
    
        }];
    [self.userImg.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    self.userImg.font = [UIFont systemFontOfSize:16];
//    self.userImg.textAlignment = NSTextAlignmentLeft;
//    self.userImg.numberOfLines = 0;
   
    //3
    //    self.moreButt = [UIButton buttonWithImageName:@"更多" selectedImageName:@"更多"];
    //    [self addSubview:self.moreButt];
    //    [self.moreButt addTarget:self action:@selector(openMor) forControlEvents:UIControlEventTouchUpInside];
    //    [self.moreButt mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.userImg.mas_centerY);
    //        make.right.offset(-15);
    //        make.height.equalTo(@14);
    //        make.width.equalTo(@14);
    //
    //    }];
    
    
    
    
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fit = [self.userImg sizeThatFits:CGSizeZero];

        NSLog(@"webView%@",NSStringFromCGSize(fit));
        self.userImg.height = fit.height;
        
    }
}
#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    self.users.text =@"活动详情";
     [self.userImg loadHTMLString:detailActModel.content baseURL:nil];
//   NSString *str = [NSString filterHTML:detailActModel.content];
//    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
//
//    self.userImg.text = str;
    [self.userImg sizeToFit];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f7f7f7'"];

    CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"]floatValue]  ;
//
        self.userImg.height = sizeHeight;
//    [self.userImg mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(sizeHeight);
//
//    }];
    [self.userImg setNeedsLayout];

    self.selectBlock(sizeHeight);

}



@end
