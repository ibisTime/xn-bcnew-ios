//
//  ShareView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/26.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "ShareView.h"

//Manager
#import "TLWXManager.h"
//Macro
#import "AppMacro.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIView+Responder.h"
#import "NSString+Extension.h"
//Extension
#import "WXApi.h"

@interface ShareView ()

@property (nonatomic , strong) CustomShareView *shareView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame shareBlock:(ShareViewTypeBlock)shareBlock {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _shareBlock = [shareBlock copy];
        
        [self addShareView];
    }
    return self;
}

- (void)addShareView
{
    NSArray *shareAry = @[@{@"image":@"wechat",
                            @"title":@"微信"},
                          @{@"image":@"timeline",
                            @"title":@"朋友圈"}];
    
    _shareView = [[CustomShareView alloc] init];
    
    _shareView.alpha = 0;
    
    [_shareView setShareAry:shareAry delegate:self];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _shareView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    BaseWeakSelf;
    _shareView.cancleBlock = ^(){
        
        [weakSelf removeFromSuperview];
    };
    
}

#pragma mark HXEasyCustomShareViewDelegate

- (void)customShareViewButtonAction:(CustomShareView *)shareView title:(NSString *)title {
    
    [self shareWithTitle:title];
}

- (void)shareWithTitle:(NSString*)title
{
 
    BaseWeakSelf;
    
    NSString *shareTitle = PASS_NULL_TO_NIL(_shareTitle).length > 0 ? _shareTitle : @"美业销帮";
    NSString *shareDesc = PASS_NULL_TO_NIL(_shareDesc).length > 0 ? _shareDesc : @"欢迎使用美业销帮";
    UIImage *shareImage =  [_shareImgStr isEqualToString:@""] || _shareImgStr == nil? [UIImage imageNamed:@"icon"] : [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_shareImgStr convertImageUrl]]]];
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = shareTitle;
    message.description = shareDesc;
    
    UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
    
    [message setThumbImage:img];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    
    webObject.webpageUrl = _shareURL;
    
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = [title isEqualToString:@"微信"] ? WXSceneSession: WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    [TLWXManager manager].wxShare = self.shareBlock;
    
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

@end
