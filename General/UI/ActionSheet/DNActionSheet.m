//
//  DNActionSheet.m
//  Happilitt
//
//  Created by 刘伟[i@liuwei.co] on 16/2/16.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

#import "DNActionSheet.h"

CGFloat DNAS_BUTTON_HEIGHT = 44;
#define DN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DNActionSheet()

/**
 *  按钮列表
 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;
/**
 *  背景
 */
@property (nonatomic, strong) UIView *darkView;

/**
 *  底部按钮区
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 *  背景window
 */
@property (nonatomic, strong) UIWindow *backWindow;

/**
 *  回调
 */
@property (nonatomic,copy)DNActionSheetBlock block;

@end

@implementation DNActionSheet

+ (instancetype)sheetWithTitles:(NSArray *)titles click:(DNActionSheetBlock)click
{
    return [[self alloc] initWithTitles:titles click:click];
}

- (instancetype)initWithTitles:(NSArray *)titles click:(DNActionSheetBlock)click
{
    if(self = [super init])
    {
        self.block = click;
        self.buttonTitles = [NSMutableArray arrayWithArray:titles];
    }
    return self;
}

- (void)show
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backWindow.hidden = NO;
    [self addSubview:self.darkView];
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.bottomView.frame;
        frame.origin.y -= frame.size.height;
        [self.bottomView setFrame:frame];
    } completion:^(BOOL finished) {
        self.darkView.userInteractionEnabled = YES;
    }];
}

- (void)dismiss:(UITapGestureRecognizer *)sender
{
    [self dismiss];
}

- (void)didButtonClicked:(id)sender
{
    [self dismiss];
    UIButton *button = sender;
    if (self.block)
    {
        self.block(button.tag);
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.darkView.alpha = 0;
        self.darkView.userInteractionEnabled = NO;
        CGRect frame = self.bottomView.frame;
        frame.origin.y += frame.size.height;
        [self.bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.backWindow.hidden = YES;
    }];
}

#pragma mark - 初始化

- (UIView *)darkView
{
    if(!_darkView)
    {
        _darkView = [UIView new];
        _darkView.userInteractionEnabled = NO;
        _darkView.frame = CGRectMake(0, 0, DN_SCREEN_WIDTH, DN_SCREEN_HEIGHT);
        _darkView.backgroundColor = [DNActionSheet DN_alphaValue:0.7 toColor:[UIColor blackColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_darkView addGestureRecognizer:tap];
    }
    return _darkView;
}

+ (UIColor *)DN_alphaValue:(CGFloat)alpha toColor:(UIColor*)color
{
    return [color colorWithAlphaComponent:alpha];
}

+ (UIImage *)DN_imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(20, 80);
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i < self.buttonTitles.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setBackgroundImage:[DNActionSheet DN_imageWithColor:[UIColor colorWithRed:251/255.0 green:103/255.0 blue:104/255.0 alpha:1]] forState:UIControlStateNormal];
            [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            
            CGFloat y = (DNAS_BUTTON_HEIGHT + 13)* i;
            button.frame = CGRectMake(20, y, DN_SCREEN_WIDTH - 40, DNAS_BUTTON_HEIGHT);
            button.layer.masksToBounds =YES;
            button.layer.cornerRadius = 5;
            [_bottomView addSubview:button];
        }
        
        // 取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = self.buttonTitles.count;
        [cancelButton setBackgroundImage:[DNActionSheet DN_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:[UIColor colorWithRed:33/255.0 green:147/255.0 blue:131/255.0 alpha:1] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat y = (DNAS_BUTTON_HEIGHT + 13)* self.buttonTitles.count;
        [cancelButton setFrame:CGRectMake(20, y, DN_SCREEN_WIDTH - 40, DNAS_BUTTON_HEIGHT)];
        cancelButton.layer.masksToBounds =YES;
        cancelButton.layer.cornerRadius = 5;
        [_bottomView addSubview:cancelButton];
        
        CGFloat bottomHeight = cancelButton.frame.origin.y + cancelButton.frame.size.height + 22;
        [_bottomView setFrame:CGRectMake(0, DN_SCREEN_HEIGHT, DN_SCREEN_WIDTH, bottomHeight)];
    }
    return _bottomView;
}

- (UIWindow *)backWindow
{
    if (!_backWindow)
    {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel  = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    return _backWindow;
}

@end
