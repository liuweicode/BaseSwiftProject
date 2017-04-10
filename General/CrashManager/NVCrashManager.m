//
//  NVCrashManager.m
//  Nova
//
//  Created by ZhouHui on 12-10-31.
//  Copyright (c) 2012年 ifa.com. All rights reserved.
//

#import "NVCrashManager.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "GTMStackTrace.h"
//#import "NSString+Ext.h"
//#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "DateUtil.h"

//获取包的UUID，用于与crash log，dsym匹配
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
//#import "UIDevice-Hardware.h"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
NSString * const UncaughtExceptionHandlerStackKey = @"UncaughtExceptionHandlerStackKey";

volatile int32_t UncaughtExceptionCount = 0;//1
#ifndef DISTRIBUTE
const int32_t UncaughtExceptionMaximum = 0;//3
#else
const int32_t UncaughtExceptionMaximum = 0;//3
#endif

#define kReportEmailAddr @"zhouhuishine@163.com"

static NVCrashManager *gNVCrashManager = nil;

#define kOperationStackMaxCount 30
NSMutableArray *ol = nil;
NSDate *AppCreateTime;

NSString *crashFilePath() {
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
																		NSUserDomainMask, YES) objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"crashstack"];
}

NSString * checkAppCrash() {
	NSString *path = crashFilePath();
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		NSError *error = nil;
		NSDictionary *fileAttri = [fileManager attributesOfItemAtPath:path error:&error];
		if (error) {
			// 如果无法读取文件属性，直接退出
			[fileManager removeItemAtPath:path error:nil];
			return nil;
		}
		unsigned long long fileSize = [[fileAttri objectForKey:NSFileSize] unsignedLongLongValue];
		if (fileSize > 100*1024) {
			// 如果文件大于100k，不需要上传
			[fileManager removeItemAtPath:path error:nil];
			return nil;
		}
		
		// 读取文件内容
		NSString *crashContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		// 删除crash文件
//		[fileManager removeItemAtPath:path error:nil];
		return crashContent;
	}
	
	return nil;
}

/**
 *  获取app的UUID，用于与dsym，app匹配
 *
 *  @return uuid
 */
static NSUUID *ExecutableUUID(void)
{
    const struct mach_header *executableHeader = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE)
        {
            executableHeader = header;
            break;
        }
    }
    
    if (!executableHeader)
        return nil;
    
    BOOL is64bit = executableHeader->magic == MH_MAGIC_64 || executableHeader->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executableHeader + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    const struct segment_command *segmentCommand = NULL;
    for (uint32_t i = 0; i < executableHeader->ncmds; i++, cursor += segmentCommand->cmdsize)
    {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_UUID)
        {
            const struct uuid_command *uuidCommand = (const struct uuid_command *)segmentCommand;
            return [[NSUUID alloc] initWithUUIDBytes:uuidCommand->uuid];
        }
    }
    
    return nil;
}

NSString *writeAppCrashStack(NSException *exception) {
    NSString *path = crashFilePath();
	NSMutableString *s = [[NSMutableString alloc] initWithCapacity:1000];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    NSString *addtime = [df stringFromDate:now];
    
//    NSString *callid = [NSString uuidString];
	
//	NetworkStatus netStatus = [[NVAppDelegate instance] netStatus];
//	NSString *networkType = nil;
//	if(netStatus != NotReachable) {
//		networkType = netStatus == ReachableViaWiFi ? @"wifi" : @"mobile";
//	}
	
	NSTimeInterval runningTime = [[DateUtil getCurrentDate] timeIntervalSinceDate:AppCreateTime];
    NSLog(@"Fuck, a crash!!!!!!!");
    //// CrashDebugLog(@"Fuck, a crash!!!!!!!");
    //[IFATechnologyStatistics event:IFA_MOB_APP_CRASH];
#ifdef DEBUG
    [s appendFormat:@"debug=1\n"];
#endif

    /*
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];// [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];


    [s appendFormat:@"Bundle UUID=%@\n", [ ExecutableUUID () UUIDString]];
    NSString* phoneUuid = [NSString stringWithFormat:@"%@", [NSString deviceUUID]];

    [s appendFormat:@"phone UUID=%@\n", phoneUuid];
    [s appendFormat:@"Bundle Id=%@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] ];
    [s appendFormat:@"short version=%@\n", version];
    [s appendFormat:@"Bundle version=%@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [s appendFormat:@"compile time =%@\n", [NSString stringWithFormat:@"Date:%s %s", __DATE__, __TIME__]];
    UIDevice *device = [UIDevice currentDevice];
    [s appendFormat:@"device name=%@\n", device.name];
    [s appendFormat:@"device model=%@\n", [device model]];
    [s appendFormat:@"device raw platform=%@\n", [device platform]];
    [s appendFormat:@"device platform=%@\n", [device platformString]];
    
    [s appendFormat:@"os =%@ %@\n", [device systemName], [device systemVersion]];
     
    
  //  [s appendFormat:@"=======================%@=============\n", callid];


    
	[s appendFormat:@"crashcount=%d\n", UncaughtExceptionCount];
    [s appendFormat:@"addtime=%@\n", addtime];

    
    AFNetworkReachabilityStatus netStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSString *networkType = nil;
    switch (netStatus) {
        case AFNetworkReachabilityStatusUnknown:
            networkType = @"unKnow";
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            networkType = @"notReachable";
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            networkType = @"wwan";
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            networkType = @"wifi";
            break;
            
        default:
            networkType = @"default";
            break;
    }
     
    [s appendFormat:@"short version=%@\n", version];
    [s appendFormat:@"network=%@\n", networkType];

    [s appendFormat:@"thread=%@\n", [NSThread currentThread]];
	[s appendFormat:@"reason=%@\n", [exception reason]];
	[s appendFormat:@"runningtime=%.0fs\n", runningTime];
	[s appendFormat:@"\noperatestack:\n%@\n\n", ol];
    
    [s appendFormat:@"\n rawCallStackReturnAddresses=%@\n", [[exception userInfo] objectForKey:@"rawCallStackReturnAddresses"]];
    [s appendFormat:@"\n rawCallStackSymbols=%@\n", [[exception userInfo] objectForKey:@"rawCallStackSymbols"]];

    [s appendFormat:@"\n\naddress:\n%@\n\n",[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    [s appendFormat:@"\n\nstack:\n%@\n\n",[[exception userInfo] objectForKey:UncaughtExceptionHandlerStackKey]];
    [s appendFormat:@"\n\nevent:\n%@\n\n", _getOnlineCrashJsonLog()];
#ifndef DEBUG
    NSFileManager *fileM = [NSFileManager defaultManager];
    if ([fileM fileExistsAtPath:path]) {
        NSFileHandle *fileH = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileH seekToEndOfFile];
        [fileH writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];
        [fileH closeFile];
    }else{
        [s writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }
     
#endif
    
    CrashDebugLog(@"%@", s);
     */
	return s;
}

void recordOperation(NSString *operation) {
	@synchronized(ol) {
		while (ol.count>=kOperationStackMaxCount) {
			[ol removeLastObject];
		}
		
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *now = [[NSDate alloc] init];
		NSString *addtime = [df stringFromDate:now];
		
		NSLog(@"%@", operation);
		[ol insertObject:[NSString stringWithFormat:@"%@ %@", addtime, operation]
				 atIndex:0];
	}
}

NSArray *callStackBacktrace()
{
	void* callstack[128];
	int frames = backtrace(callstack, 128);
	char **strs = backtrace_symbols(callstack, frames);
	
	int i;
	NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	for (i = 0; i<frames; i++)
	{
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	}
	free(strs);
	
	return backtrace;
}

void HandleException(NSException *exception)
{
    NSLog(@"HandleException");
	recordOperation(@"[ExceptionCrash]");
	NSString *stack = GTMStackTraceFromException(exception);
	
	OSAtomicIncrement32(&UncaughtExceptionCount);
	
	NSArray *callStack = callStackBacktrace();
	NSMutableDictionary *userInfo =
	[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
	 setObject:callStack
	 forKey:UncaughtExceptionHandlerAddressesKey];
	if (stack) {
		[userInfo
		 setObject:stack
		 forKey:UncaughtExceptionHandlerStackKey];
	}
	
    [userInfo setObject:[[exception callStackReturnAddresses] description] forKey:@"rawCallStackReturnAddresses"];
    [userInfo setObject:[[exception callStackSymbols] description] forKey:@"rawCallStackSymbols"];
    
	[gNVCrashManager
	 performSelectorOnMainThread:@selector(handleException:)
	 withObject:
	 [NSException
	  exceptionWithName:[exception name]
	  reason:[exception reason]
	  userInfo:userInfo]
	 waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	recordOperation(@"[SignalCrash]");
	OSAtomicIncrement32(&UncaughtExceptionCount);
	
	NSMutableDictionary *userInfo =
	[NSMutableDictionary
	 dictionaryWithObject:[NSNumber numberWithInt:signal]
	 forKey:UncaughtExceptionHandlerSignalKey];
	
	NSArray *callStack = callStackBacktrace();
	[userInfo
	 setObject:callStack
	 forKey:UncaughtExceptionHandlerAddressesKey];
	
	[gNVCrashManager
	 performSelectorOnMainThread:@selector(handleException:)
	 withObject:
	 [NSException
	  exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
	  reason:[NSString stringWithFormat:@"Signal %d was raised.",signal]
	  userInfo:userInfo]
	 waitUntilDone:YES];
}


#pragma mark NVCrashManager
@implementation NVCrashManager {
	BOOL exitRunning;
	NSString *tempCrashContent;
	
	NSException *lastException;
}

@synthesize delegate = _delegate;

+ (void)install {
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGQUIT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGTRAP, SignalHandler);
	signal(SIGABRT, SignalHandler);
	signal(SIGEMT, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGSYS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
	signal(SIGALRM, SignalHandler);
	signal(SIGXCPU, SignalHandler);
	signal(SIGXFSZ, SignalHandler);
	
	if (!gNVCrashManager) {
		gNVCrashManager = [[NVCrashManager alloc] init];
	}
}

+ (void)installWithDelegate:(id<NVCrashManagerDelegate>)source{
    [NVCrashManager install];
    gNVCrashManager.delegate = source;
}

- (id)init {
	self = [super init];
	if (self) {
		AppCreateTime = [[NSDate alloc] init];
		ol = [[NSMutableArray alloc] initWithCapacity:kOperationStackMaxCount];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
		
		NSString *crash = checkAppCrash();
		if (crash.length>0) {
			[self performSelectorInBackground:@selector(reportAppCrash:) withObject:crash];
		}
	}
	return self;
}

- (void)applicationWillEnterForegroundNotification {
	recordOperation(@"[UIApplicationWillEnterForegroundNotification]");
}

- (void)applicationDidEnterBackground {
	recordOperation(@"[UIApplicationDidEnterBackgroundNotification]");
	if (lastException) {
		[self killApp];
	}
}

- (void)applicationDidBecomeActiveNotification {
	recordOperation(@"[UIApplicationDidBecomeActiveNotification]");
}

- (void)applicationWillResignActiveNotification {
	recordOperation(@"[UIApplicationWillResignActiveNotification]");
}

- (void)applicationDidReceiveMemoryWarningNotification {
	recordOperation(@"[UIApplicationDidReceiveMemoryWarningNotification]");
}

- (void)applicationWillTerminateNotification {
	recordOperation(@"[UIApplicationWillTerminateNotification]");
}

- (void)reportAppCrash:(NSString *)crashContent {
    if ([self.delegate respondsToSelector:@selector(uploadCrashContent:result:)]){
        NSString *crashFile = crashFilePath();
        [self.delegate uploadCrashContent:crashContent result:^(BOOL successed) {
            if (successed) {
                [[NSFileManager defaultManager] removeItemAtPath:crashFile error:nil];
            }else{
                
            }
        }];
    }
//	NSURL *url = [NSURL URLWithString:@"http://stat.api.ifa.com/utm.js?v=iphonecr"];
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
//	[request setHTTPMethod:@"POST"];
//	
//	[request setHTTPBody:[crashContent dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	NSURLResponse *response;
//	NSError *error = nil;
//	[NSURLConnection sendSynchronousRequest:request
//						  returningResponse:&response
//									  error:&error];
//	if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200)) {
//		// successful report, mark it as such
//		NSString *crashFile = crashFilePath();
//		[[NSFileManager defaultManager] removeItemAtPath:crashFile error:nil];
//		NSLog(@"----------crash uploaded!");
//	} else {
//		NSLog(@"----------crash upload failed!");
//	}
}

- (void)handleException:(NSException *)exception
{
	lastException = exception;
	NSMutableString *crash = [NSMutableString stringWithString:writeAppCrashStack(exception)];
	// 崩溃信息增加countinue=1，但不写入文件中。可以用该标记来表明程序是否继续运行了。
	[crash appendFormat:@"\nCountinue=1"];
	
	// 不允许崩溃次数多余UncaughtExceptionMaximum规定的次数
	if (UncaughtExceptionCount>UncaughtExceptionMaximum) {
		exitRunning = YES;
	}
	// 不允许连续两次发生signal错误
	static BOOL lastExceptionIsFromSignal = NO;
	BOOL isFromSignal = [[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName];
	if (isFromSignal && lastExceptionIsFromSignal) {
		exitRunning = YES;
	}
	lastExceptionIsFromSignal = isFromSignal;
#ifdef DEBUG
    if (!exitRunning) {
        [self performSelector:@selector(showAlert:) withObject:crash afterDelay:0];
    }
#endif
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	BOOL hasRecordException = NO;
	while (!exitRunning)
	{
        
		for (NSString *mode in (__bridge NSArray *)allModes)
		{
			CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
		}
		
		if (!hasRecordException) {
			hasRecordException = YES;
			[self performSelectorInBackground:@selector(reportAppCrash:) withObject:crash];
		}
	}
	
	CFRelease(allModes);
	
	// kill app
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGQUIT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGTRAP, SIG_DFL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGEMT, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGSYS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	signal(SIGALRM, SIG_DFL);
	signal(SIGXCPU, SIG_DFL);
	signal(SIGXFSZ, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    //[self dismissModalViewControllerAnimated:YES];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissModalViewControllerAnimated:YES];
}

- (void)sendAndContinue {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
		mail.mailComposeDelegate = self;
		[mail setMessageBody:tempCrashContent isHTML:NO];
		[mail setToRecipients:[NSArray arrayWithObject:kReportEmailAddr]];
		[mail setSubject:@"iPhone客户端崩溃报告"];
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentModalViewController:mail animated:YES];
	}
	
	tempCrashContent = nil;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
	if (anIndex == 0)
	{
		//Quite
		exitRunning = YES;
	} else if (anIndex == 2) {
		[self performSelector:@selector(sendAndContinue) withObject:nil afterDelay:0.0];
	} else {
		tempCrashContent = nil;
	}
}

- (void)showAlert:(NSString *)crash {
	// 将崩溃详情复制到粘贴板
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
	[gpBoard setValue:crash forPasteboardType:@"public.utf8-plain-text"];
	
	tempCrashContent = crash;
	
	// 调试模式：弹出对话框询问是否发送崩溃报告。
	UIAlertView *alert =
	[[UIAlertView alloc]
	 initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
	 message:[NSString stringWithFormat:NSLocalizedString(
														  @"崩溃信息已复制到粘贴板！\n\n"
														  @"\"继续运行\": 程序继续运行，但可能变的不太稳定；\n"
														  @"\"发送邮件\": 将崩溃信息发送到开发团队的电子邮箱中，供我们调试(需要在设置中配置过邮箱)，之后程序将继续运行；\n"
														  @"\"退出\": 强制关闭程序。\n\n"
														  @"崩溃信息详情如下：\n%@", nil),crash]
	 delegate:self
	 cancelButtonTitle:@"退出"
	 otherButtonTitles:@"继续运行", @"发送邮件", nil];
	[alert show];
}

- (int32_t)crashCount {
	return UncaughtExceptionCount;
}

- (void)killApp {
	if (!lastException) {
		return;
	}
	
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGQUIT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGTRAP, SIG_DFL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGEMT, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGSYS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	signal(SIGALRM, SIG_DFL);
	signal(SIGXCPU, SIG_DFL);
	signal(SIGXFSZ, SIG_DFL);
	
	if ([[lastException name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[lastException userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[lastException raise];
	}
}

+ (NSDate *)getAppCreateTime {
    return AppCreateTime;
}

@end
