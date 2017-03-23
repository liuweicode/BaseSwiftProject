//
//  FileUtils.h
//  DaQu
//
//  Created by 刘伟 on 16/9/28.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (unsigned long long) folderSizeAtPath: (const char*)folderPath;

@end
