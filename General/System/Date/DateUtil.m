//
//  DateUtil.m
//  DaQu
//
//  Created by 刘伟 on 9/5/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

#import "DateUtil.h"
#import <mach/mach_time.h>

@implementation DateUtil

+(double)getCPUClick
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0f;
    uint64_t elapsed = mach_absolute_time();
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (double)nanos / NSEC_PER_SEC;
    
}

+ (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

@end
