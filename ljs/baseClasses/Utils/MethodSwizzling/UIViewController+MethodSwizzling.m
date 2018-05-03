//
//  UIViewController+MethodSwizzling.m
//  iOS7-NavigationController-Sample
//
//  Created by 魏哲 on 14-5-16.
//
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

#ifdef DEBUG

#define ClassNameLog(x) NSLog(@"\n\n*** %@ released ***\n", x);

#else

#define ClassNameLog(x)

#endif


@implementation UIViewController (MethodSwizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            Method originMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzling_viewDidAppear:));
            method_exchangeImplementations(originMethod, swizzledMethod);
            
            // detect controller dealloc
            Method originDealloc = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
            Method swizzledDealloc = class_getInstanceMethod([self class], @selector(bs_dealloc));
            method_exchangeImplementations(originDealloc, swizzledDealloc);

        }
    });
}


- (void)swizzling_viewDidAppear:(BOOL)animated
{
    [self swizzling_viewDidAppear:animated];
    

    NSLog(@"\n** %@ ** viewDidAppear", [self class]);
    
    // 设置系统滑动手势可以响应
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// detect controller dealloc
- (void)bs_dealloc {
    
    ClassNameLog([self class]);
    [self bs_dealloc];
}


@end
