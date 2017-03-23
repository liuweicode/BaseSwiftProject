//
//  FileUtils.m
//  DaQu
//
//  Created by 刘伟 on 16/9/28.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

#import "FileUtils.h"
#include <dirent.h>
#include <sys/stat.h>

@implementation FileUtils

+ (unsigned long long) folderSizeAtPath: (const char*)folderPath
{
    unsigned long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR
            && child->d_name[0] == '.'
            && (child->d_name[1] == 0 // ignore .
                ||
                (child->d_name[1] == '.' && child->d_name[2] == 0) // ignore dir ..
                ))
            continue;
        
        long folderPathLength = strlen(folderPath);
        char childPath[1024]; // child
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self folderSizeAtPath:childPath]; //
            // add folder size
            struct stat st;
            if (lstat(childPath, &st) == 0)
                folderSize += st.st_size;
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if (lstat(childPath, &st) == 0)
                folderSize += st.st_size;
        }
    }
    return folderSize;
}

@end
