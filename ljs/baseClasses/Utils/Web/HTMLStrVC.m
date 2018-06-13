//
//  HTMLStrVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HTMLStrVC.h"
#import <WebKit/WebKit.h>
#import "APICodeMacro.h"
#import "AppConfig.h"

@interface HTMLStrVC ()<WKNavigationDelegate,UIWebViewDelegate>

@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic, strong) UIButton *Submit;
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HTMLStrVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *Submit = [UIButton buttonWithType:UIButtonTypeCustom];
//    [Submit setTitle:@"发布" forState:UIControlStateNormal];
//
//    [Submit addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:Submit];
//    [Submit mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.equalTo(@0);
//        make.width.height.equalTo(@(100));
//
//    }];
//    self.Submit =Submit;
//    self.navigationItem.titleView = Submit;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(clickBack)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
    
    NSLog(@"%@",[AppConfig config].qiniuDomain);
    NSArray *arr =   [self.ckey componentsSeparatedByString:@"?"];
    self.ckey = arr[0];
    NSString *ownerId ;
    if ([TLUser user].userId) {
        ownerId = [TLUser user].userId;
    }else{
        
        ownerId = @"";
    }
    
    UIWebView *web = [[UIWebView alloc] init];
    
    web.delegate = self;
    self.web =web;
    
    [self.view addSubview:web];
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    return;
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"h5url";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"cvalue"]];
        
        NSString *strurl=[NSString stringWithFormat:@"%@/news/addNews.html?ownerId=%@",shareUrl,ownerId];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]]];

//        NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
//        NSString *html = [NSString stringWithFormat:@"%@/charts/index.html?symbol=%@&exchange=%@",shareUrl, symbol, platform.exchangeEname];
//
//        [self.kLineView loadRequestWithString:html];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    // Do any additional setup after loading the view.

//    [self requestContent];
}
- (void)clickBack
{
    

    NSLog(@"发布资讯");
    
    NSString *result = [self.web stringByEvaluatingJavaScriptFromString:@"doSubmit();"];
    
    NSLog(@"%@",result);
    [TLAlert alertWithSucces:@"发布成功，请耐心等待"];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}






//UIWebViewDelegate协议方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    
    UIWebView *web = webView;
    
    //获取所有的html
    
    NSString *allHtml = @"document.documentElement.innerHTML";
    
    //获取网页title
    
    NSString *htmlTitle = @"document.title";
    
    //获取网页的一个值
    
    NSString *htmlNum = @"document.getElementById('title').innerText";
    
    //最后调用 stringByEvaluatingJavaScriptFromString 获取相应内容
    
    //例如 如下代码获取Html内容
    
    NSString *allHtmlInfo = [web stringByEvaluatingJavaScriptFromString:allHtml];
}

- (void)requestContent {
    
    NSString *name = @"";
    
    NSString *ckey = @"";
    
    switch (self.type) {
            
        case HTMLTypeAboutUs: {
            
            ckey = @"about_us";
            
            name = @"关于我们";
            
        } break;
            
    }

    self.navigationItem.titleView = [UILabel labelWithTitle:name frame:CGRectMake(0, 0, 200, 44)];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = ckey;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init

- (void)initWebView {

    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
    [self loadWebWithString:self.htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
