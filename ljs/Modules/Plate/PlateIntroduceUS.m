//
//  PlateIntroduceUS.m
//  ljs
//
//  Created by shaojianfei on 2018/6/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateIntroduceUS.h"
#import "UIBarButtonItem+convience.h"
#import "InfoDetailShareView.h"
#import "TLWXManager.h"
#import "QQManager.h"
#import "WebVC.h"
#import "APICodeMacro.h"
#import "NSString+Extension.h"
#import "TFHpple.h"
@interface PlateIntroduceUS ()

@property (nonatomic ,strong) UILabel *contentLab;

@property (nonatomic ,strong) NSString *shareUrl;

@property (nonatomic ,strong) InfoDetailShareView *shareView;


@end

@implementation PlateIntroduceUS

- (void)viewDidLoad {
//    self.title = @"介绍我们";
    
    [super viewDidLoad];
    [self initSubViews];
    [self getShareUrl];
    // Do any additional setup after loading the view.
}
- (InfoDetailShareView *)shareView {
    
    if (!_shareView) {
        
        BaseWeakSelf;
        
        _shareView = [[InfoDetailShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _shareView.shareBlock = ^(ThirdType type) {
            
            [weakSelf shareEventsWithType:type];
        };
    }
    return _shareView;
}
#pragma mark - 分享
- (void)shareEventsWithType:(ThirdType)type {
    
    NSString *previewImage;
    
//    if (self.detailModel.pics.count > 0) {
//
//        previewImage = [self.detailModel.pics[0] convertImageUrl];
//    }
//
    NSString *desc = [self substringFromArticleContent:self.content];
    
    switch (type) {
        case ThirdTypeWeChat:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.mineModel.name
                                            desc:self.content
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeTimeLine:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneTimeline
                                           title:self.mineModel.name
                                            desc:self.content
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeQQ:
        {
            [QQManager manager].qqShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                }else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
            [QQManager qqShareWebPageWithScene:0
                                         title:self.mineModel.name
                                          desc:desc
                                           url:self.shareUrl
                                  previewImage:nil];
            
        }break;
            
        case ThirdTypeWeiBo:
        {
            
        }break;
            
        default:
            break;
    }
}
- (NSString *)substringFromArticleContent:(NSString *)content {
    
    //截取富文本的内容
    NSData *htmlData = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *classArr = [hpple searchWithXPathQuery:@"//div"];
    
    NSMutableString *string = [NSMutableString string];
    
    for (TFHppleElement *element in classArr) {
        
        if (element.content) {
            
            [string add:element.content];
        }
    }
    //文章描述
    //    NSString *desc = [string substringToIndex:50];
    
    return @"";
}

- (void)initSubViews
{
    self.contentLab = [UILabel labelWithBackgroundColor:kBackgroundColor textColor:kTextColor font:16.0];
    [self.view addSubview:self.contentLab];
    self.contentLab.numberOfLines = 0;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    self.contentLab.text = self.content;
    [UIBarButtonItem addRightItemWithTitle:@"分享" titleColor:kWhiteColor frame:CGRectMake(0, 0, 60, 50) vc:self action:@selector(introduceUs)];
    
}
- (void)introduceUs
{
    
    [self checkLogin:^{
        [self.shareView show];
        
    }];
    
    
}
- (void)getShareUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"h5Url";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.shareUrl = [NSString stringWithFormat:@"%@/blockShare/blockShare.html?code=%@", responseObject[@"data"][@"cvalue"], self.mineModel.code];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
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
