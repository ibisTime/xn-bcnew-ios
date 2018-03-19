//
//  BaseWKWebViewController.m
//  ArtInteract
//
//  Created by 蔡卓越 on 16/9/26.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseWKWebViewController.h"

@interface BaseWKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end

@implementation BaseWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

- (WKWebView *)wkWebView {
    
    if (_wkWebView == nil) {
        
        // 用于注入js
        
        WKUserContentController *userCC = [[WKUserContentController alloc] init];
        
        [userCC addScriptMessageHandler:self name:@"webviewEvent"];
        
        // [userCC addUserScript:userScript];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config.userContentController = userCC;
        
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) configuration:config];
        
        self.wkWebView.UIDelegate = self;
        self.wkWebView.navigationDelegate = self;
        [self.view addSubview:self.wkWebView];
            
    }
    
    return _wkWebView;
}

- (void)wkWebViewRequestWithURL:(NSString *)url {
    

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
//    NSString *phpSession = [UserDefaultsUtil getUsetDefaultCookie];
//    NSString *cookieString = [NSString stringWithFormat:@"%@=%@",@"PHPSESSID",phpSession];
//    [urlRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
//
//    
//    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
//    [urlRequest addValue:systemVersion forHTTPHeaderField:@"User-Agent"];
    
    [self.wkWebView loadRequest:urlRequest];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    
}


#pragma mark - WKNavigationDelegate
/* 1.在发送请求之前，决定是否跳转  */
//- (void)webView:(WKWebView *)webView
//decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
//decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

/* 2.页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

       // [self showIndicatorOnWindowWithMessage:@"加载中..."];
}
/* 3.在收到服务器的响应头，根据response相关信息，决定是否跳转。 */
//- (void)webView:(WKWebView *)webView
//decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
//decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//
//}

/* 4.开始获取到网页内容时返回，需要注入JS，在这里添加 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {


}

/* 5.页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    //[self hideIndicatorOnWindow];
}
/* error - 页面加载失败时调用 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {

    [TLAlert alertWithInfo:@"网络不太好"];
}

/* 其他 - 处理服务器重定向Redirect */
//- (void)webView:(WKWebView *)webView
//didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//
//
//}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {

    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {



}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//
//    
//}


@end
