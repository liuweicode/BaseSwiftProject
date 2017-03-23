//
//  DNActionSheet.h
//  Happilitt
//
//  Created by 刘伟[i@liuwei.co] on 16/2/16.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DNActionSheetBlock)(NSInteger buttonIndex);

extern CGFloat DNAS_BUTTON_HEIGHT;

@interface DNActionSheet : UIView

+ (instancetype)sheetWithTitles:(NSArray *)titles click:(DNActionSheetBlock)click;

- (void)show;

@end
