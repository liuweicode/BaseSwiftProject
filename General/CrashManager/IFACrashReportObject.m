//
//  IfaCrashReportObject.m
//  IFAAdviser
//
//  Created by Leo on 15/6/13.
//  Copyright (c) 2015年 IFA. All rights reserved.
//

#import "IFACrashReportObject.h"
#import "NVCrashManager.h"
//#import "IFACrashReportReqM.h"

static IFACrashReportObject *ifaGCrashReportO = nil;

@interface IFACrashReportObject()<NVCrashManagerDelegate>

@end

@implementation IFACrashReportObject

+ (void)begin{
    if (ifaGCrashReportO){
        
    }else{
        ifaGCrashReportO = [[IFACrashReportObject alloc ]init];
    }
}


- (id)init{
    self = [super init];
    if (self){
        [NVCrashManager installWithDelegate:self];
    }
    return self;
}

#pragma mark - NVCrashManagerDelegate
- (void)uploadCrashContent:(NSString *)content result:(void (^)(BOOL))result{
    /*IFACrashReportReqM *reqM = [IFACrashReportReqM new];
    reqM.abnormal = content;
    [IFABaseHttpRequestDataModel requestWithMutilRequest:@[reqM] success:^(id responseObject, NSArray *responseArray) {
        result(YES);
    } failed:^(NSError *error) {
        DebugLog(@"upload crash fail:%@", error);
    }];
     */
}

@end
