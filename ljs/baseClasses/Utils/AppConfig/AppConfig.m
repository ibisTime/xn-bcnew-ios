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
            self.qiniuDomain = @"http://image.wallet.hichengdai.com";
        }break;
        case RunEnvDev: {
            self.addr = @"http://47.97.214.223:2301";
            self.qiniuDomain = @"http://p6aev1fk1.bkt.clouddn.com";
        }break;
            
        case RunEnvTest: {
            

//            self.addr = @"http://47.75.175.18:2201"; //生产
            self.addr = @"http://47.75.175.18:2205";//研发

            self.qiniuDomain = @"http://p6aev1fk1.bkt.clouddn.com";
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
    
    return @"aeda9d2b0b7275cad82efc301e991d42";
}

- (NSString *)qqId {
    
    return @"101824324";
}

- (NSString *)pushKey {
    return @"1c959a496681efca3fd77e30";
}
@end
