//
//  BaseWKWebViewController.h
//  ArtInteract
//
//  Created by 蔡卓越 on 16/9/26.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic , assign) CGRect webViewFrame;

@property (nonatomic, copy) NSString *titleName;

- (void)wkWebViewRequestWithURL:(NSString *)url;

@end
