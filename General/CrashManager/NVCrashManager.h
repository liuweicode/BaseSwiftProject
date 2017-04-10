//
//  NVCrashManager.h
//  Nova
//
//  Created by ZhouHui on 12-10-31.
//  Copyright (c) 2012年 ifa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
//#import "IFAGlobal.h"

@protocol NVCrashManagerDelegate;
@interface NVCrashManager : NSObject <MFMailComposeViewControllerDelegate>

+ (void)install;

/**
 *  @return App开始时间
 */
+ (NSDate *)getAppCreateTime;

/**
 *  完成install并设置代理
 *
 *  @param source 代理，用于完成网络请求
 */
+ (void)installWithDelegate:(id<NVCrashManagerDelegate>)source;

@property (nonatomic, assign) id <NVCrashManagerDelegate> delegate;

@end

extern void recordOperation(NSString *operation);

@protocol NVCrashManagerDelegate <NSObject>
@optional
// 如果程序发生过崩溃，当切换到后台时，如果返回YES，则不会退出程序；否则会退出程序
- (BOOL)unKillAppWhenEnterBackgroundAndHadCrashed;

/**
 *  需要上传crash
 *
 *  @param filePath crash文件路径
 */
- (void)uploadCrashContent:(NSString *)content result:(void(^)(BOOL successed))result;

@end
