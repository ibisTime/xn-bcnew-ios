//
//  NSString+Date.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "NSString+Date.h"
#import "CoinHeader.h"
#import "AppMacro.h"

@implementation NSString (Date)

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"]; //NSLocale(localeIdentifier: "en")
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    //国际时间
    NSDate* localDate = [[NSDate alloc] init];
    //获得的是计算机上的时间
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    //得到本地时间与国际时间的时间差
    NSInteger interval = [zone secondsFromGMTForDate:localDate];
    
    return [date dateByAddingTimeInterval:interval];
}

+ (NSDate *)getLoaclDateWithFormatter:(NSString *)formatter {
    
    //国际时间
    NSDate* localDate = [[NSDate alloc] init];
    //获得的是计算机上的时间
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    //得到本地时间与国际时间的时间差
    NSInteger interval = [zone secondsFromGMTForDate:localDate];
    
    return [localDate dateByAddingTimeInterval:interval];
    
}

+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter {
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        return @"";
    }
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    return  [NSString stringFromDate:createDate formatter:formatter];
}

+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr {
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        return nil;
    }
    
    NSString *dataStr = nil;
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    
    dataStr = [NSString stringFromDate:createDate formatter:@"yyyy-MM-dd HH:mm:ss"];
    //dataStr = [NSString stringFromDate:createDate formatter:@"YYYY-MM-dd"];
    NSTimeInterval timeInterval = ABS([createDate timeIntervalSinceNow]);
    if (timeInterval/60 <= 1) {
        dataStr = @"刚刚";
    }
    else if (timeInterval/3600 <= 1) {
        NSInteger minutes = timeInterval/60;
        dataStr = [NSString stringWithFormat:@"%li分钟前", (long)minutes];
    }
    else if (timeInterval/3600/24 <= 1) {
        NSInteger hours = timeInterval/3600;
        dataStr = [NSString stringWithFormat:@"%li小时前", (long)hours];
    }
    else if (timeInterval/3600/24 <= 2) {
        dataStr = @"昨天";
    }
    else if (timeInterval/3600/24 <= 3) {
        dataStr = @"前天";
    }
    
    return dataStr;
    
}

- (NSDateComponents*)timeIntetvalStringToDateComponents {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
}

+ (NSDateComponents*)getCurrentComponents {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *currentDate = [NSDate date];
    comps = [calendar components:unitFlags fromDate:currentDate];
    return  comps;
}

+ (NSString*)stringWithTimeStamp:(NSString*)timeStampStr {
    
    return [self stringWithTimeStamp:timeStampStr formatter:nil];
}

+ (NSString *)stringWithTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter {
    
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        
        return @"";
    }
    
    NSString *timeStr = @"";
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    
    if (formatter == nil) {
        
        formatter = @"yyyy.MM.dd HH:mm";
    }
    
    timeStr = [NSString stringFromDate:timeDate formatter:formatter];
    
    return timeStr;
}

+ (NSString *)stringWithTimeString:(NSString *)timeString timeFormatter:(NSString *)timeFormatter fotmatter:(NSString *)formatter {
    
    NSString *timeStr = @"";
    NSDate *date = [NSString dateFromString:timeString formatter:timeFormatter];
    timeStr = [NSString stringFromDate:date formatter:formatter];
    
    return timeStr;
}

+ (NSString *)stringWithTimeStr:(NSString *)timeStampStr format:(NSString *)format {
    
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        
        return nil;
    }
    
    NSString *dataStr = nil;
    NSDate *createDate = [NSString dateFromString:timeStampStr formatter:format];
    
    NSDate *localDate = [[NSDate alloc] init];
    
    //转换时间格式
    //对比两个时间
    
    NSTimeInterval seconds = [localDate timeIntervalSinceDate:createDate];
    
    if (seconds/3600/24/365 > 1) {
        
        NSInteger year = seconds/3600/24/365;
        
        dataStr = [NSString stringWithFormat:@"%ld年前", year];
    }
    
    if (seconds/3600/24/30 > 1) {
        
        NSInteger month = seconds/3600/24/30;
        
        dataStr = [NSString stringWithFormat:@"%ld月前", month];
    }
    
    if (seconds/3600/24 > 1) {
        
        NSInteger day = seconds/3600/24;
        
        dataStr = [NSString stringWithFormat:@"%ld天前", day];
        
        return dataStr;
    }
    
    if (seconds/60 <= 1) {
        
        dataStr = @"刚刚";
        
    } else if (seconds/60 < 60) {
        
        NSInteger minute = seconds/60;
        
        dataStr = [NSString stringWithFormat:@"%ld分钟前", minute];
        
    } else {
        
        NSInteger hour = seconds/3600;
        
        dataStr = [NSString stringWithFormat:@"%ld小时前", hour];
        
    }
    
    return dataStr;
}

- (NSString *)convertToTimelineDate {
    
    //后期改为类似于微信的那种做法
    return  [self convertToDetailDate];
    
}

- (NSString *)convertToDetailDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
    
}

- (NSString *)convertDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy/MM/dd/hh:mm";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
}

- (NSString *)convertDateWithFormat:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = format;
//    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
    
}

+ (NSString*)weekdayStringFromDate:(NSString*)date {
    
    if (date == nil) {
        
        return @"";
    }
    NSDate *inputDate = [NSString dateFromString:date formatter:@"MMM dd, yyyy hh:mm:ss aa"];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置为0时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    [calendar setTimeZone: timeZone];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday - 1];
}
- (NSString *)formateDateStr
{

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd/hh:mm"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        NSDate * needFormatDate = [dateFormatter dateFromString:self];
        
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSLog(@"time----%f",time);
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    
@end
