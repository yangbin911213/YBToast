//
//  Toast.m
//  ToastDemo
//
//  Created by yangbin on 16/8/23.
//  Copyright © 2016年 yangbin. All rights reserved.
//

#import "Toast.h"

static const CGFloat kComponentHeightPadding = 5; // 提示框距离文字高度的间隔距离
static const CGFloat kComponentWidthPadding = 10; // 提示框距离文字宽度的间隔距离
#define CURRENT_TOAST_TAG 666666

@interface Toast ()

@property (nonatomic, strong) ToastSetting *toastSetting;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) NSString *textString;

@end

@implementation Toast

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_toastSetting) {
            _toastSetting = [ToastSetting instance];
        }
        _textString = @"网络出错，请稍后重试";
    }
    return self;
}

+ (Toast *)instance {
    static Toast *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _obj = [[Toast alloc] init];
    });
    return _obj;
}

- (void)showWithText:(NSString *)text {
    
    UIFont *font = [UIFont systemFontOfSize:_toastSetting.fontSize];
    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(280, 60)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize textSize = rect.size;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, textSize.width + kComponentWidthPadding * 2, textSize.height + kComponentHeightPadding * 2);
    label.center = CGPointMake(button.frame.size.width / 2, button.frame.size.height / 2);

    CGRect lbfrm = label.frame;
    lbfrm.origin.x = ceil(lbfrm.origin.x);
    lbfrm.origin.y = ceil(lbfrm.origin.y);
    label.frame = lbfrm;
    [button addSubview:label];
    
    button.backgroundColor = _toastSetting.backGroundColor;
    button.alpha = _toastSetting.alpha;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = _toastSetting.cornerRadius;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    CGPoint point = CGPointZero;
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    double version = [[[UIDevice currentDevice] systemVersion] doubleValue];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            if (_toastSetting.toastGravity == ToastGravityTop) {
                point = CGPointMake(window.frame.size.width / 2, 45);
            } else if (_toastSetting.toastGravity == ToastGravityBottom) {
                point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
            } else if (_toastSetting.toastGravity == ToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                point = _toastSetting.postition;
            }
            
            point = CGPointMake(point.x , point.y );
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
        {
            if (version < 8.0) {
                button.transform = CGAffineTransformMakeRotation(M_PI);
            }
            
            float width = window.frame.size.width;
            float height = window.frame.size.height;
            
            if (_toastSetting.toastGravity  == ToastGravityTop) {
                point = CGPointMake(width / 2, height - 45);
            } else if (_toastSetting.toastGravity  == ToastGravityBottom) {
                point = CGPointMake(width / 2, 45);
            } else if (_toastSetting.toastGravity  == ToastGravityCenter) {
                point = CGPointMake(width/2, height/2);
            } else {
                // TODO : handle this case
                point = _toastSetting.postition;
            }
            
            point = CGPointMake(point.x , point.y);
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            if (version < 8.0) {
                button.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
            }
            
            if (_toastSetting.toastGravity  == ToastGravityTop) {
                point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
            } else if (_toastSetting.toastGravity  == ToastGravityBottom) {
                point = CGPointMake(45,window.frame.size.height / 2);
            } else if (_toastSetting.toastGravity  == ToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                // TODO : handle this case
                point = _toastSetting.postition;
            }
            
            point = CGPointMake(point.x, point.y );
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            if (version < 8.0) {
                button.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }
            
            if (_toastSetting.toastGravity  == ToastGravityTop) {
                point = CGPointMake(45, window.frame.size.height / 2);
            } else if (_toastSetting.toastGravity  == ToastGravityBottom) {
                point = CGPointMake(window.frame.size.width - 45, window.frame.size.height/2);
            } else if (_toastSetting.toastGravity  == ToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                // TODO : handle this case
                point = _toastSetting.postition;
            }
            
            point = CGPointMake(point.x, point.y );
            break;
        }
        default:
            break;
    }
    
    button.center = point;
    button.frame = CGRectIntegral(button.frame);
    
    NSTimeInterval duration = (CGFloat)text.length / 10;
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:duration                                             target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    button.tag = CURRENT_TOAST_TAG;

    UIView *currentToast = [window viewWithTag:CURRENT_TOAST_TAG];
    if (currentToast != nil) {
        [currentToast removeFromSuperview];
    }
    
    button.alpha = 0;
    [window addSubview:button];
    [UIView beginAnimations:nil context:nil];
    button.alpha = 1;
    [UIView commitAnimations];
    
    _view = button;
    
    [button addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];

}

- (void)hideToast:(UIButton *)button {
    [UIView animateWithDuration:_toastSetting.dismissDuration animations:^{
        
        _view.alpha = 0;
    }];
}
@end

@implementation ToastSetting

- (instancetype)init {
    self = [super init];
    if (self) {
        _toastGravity = ToastGravityCenter;
        _duration = 0.5;
        _fontSize = 16.0;
        _cornerRadius = 5.0;
        _alpha = 0.7;
        _dismissDuration = 0.3;
        _backGroundColor = [UIColor blackColor];
    }
    return self;
}

+ (ToastSetting *)instance {
    static ToastSetting *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[ToastSetting alloc] init];
    });
    return _obj;
}

@end