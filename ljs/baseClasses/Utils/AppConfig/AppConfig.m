//
//  AppConfig.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppConfig.h"

void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    self.companyCode = @"CD-BCINF0019";
    self.systemCode = @"CD-BCINF0019";
    switch (_runEnv) {
        case RunEnvRelease: {
//            self.addr = @"http://47.97.214.223:2201";
            self.addr = @"http://info.front.faedy.com/api";
            self.qiniuDomain = [[NSUserDefaults standardUserDefaults]objectForKey:@"Get_Seven_Cattle_Address"];
        }break;
        case RunEnvDev: {
            self.addr = @"http://47.97.214.223:2301";
            self.qiniuDomain = [[NSUserDefaults standardUserDefaults]objectForKey:@"Get_Seven_Cattle_Address"];
        }break;
            
        case RunEnvTest: {
            

//            self.addr = @"http://47.75.175.18:2201"; //生产
            self.addr = @"http://47.75.175.18:2205";//研发

            self.qiniuDomain = [[NSUserDefaults standardUserDefaults]objectForKey:@"Get_Seven_Cattle_Address"];
        }break;
    }
}

- (NSString *)getUrl {

    return self.addr;
}

- (NSString *)wxKey {
    
    return @"45b1577ecb4e9503037acf4c118d872c";
}

- (NSString *)qqKey {
    
    return @"26ed6bc89f45a6a936362a344fbc33b8";
}

- (NSString *)qqId {
    
    return @"101824028";
}

- (NSString *)pushKey {
    return @"c147abfaf26b66762a5cb19f";
}
@end
