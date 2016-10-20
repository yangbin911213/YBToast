//
//  Toast.h
//  ToastDemo
//
//  Created by yangbin on 16/8/23.
//  Copyright © 2016年 yangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 弹出位置
typedef enum ToastGravity {
    ToastGravityTop = 1000, // 顶部弹出
    ToastGravityBottom, // 底部
    ToastGravityCenter // 中间
}ToastGravity ;

@class Toast;
@interface Toast : NSObject

+ (Toast *)instance;

// 根据文字，弹出toast
- (void)showWithText:(NSString *)text;

@end

#define kToastSetting [ToastSetting instance]

@interface ToastSetting : NSObject
// 消失间隔时间
@property (nonatomic, assign) CGFloat duration;
// 消失延迟时间
@property (nonatomic, assign) CGFloat dismissDuration;
// 显示位置(顶部/中间/底部)
@property (nonatomic, assign) ToastGravity toastGravity;
// 点位置
@property (nonatomic, assign) CGPoint postition;
// 字体大小
@property (nonatomic, assign) CGFloat fontSize;
// 边框圆角
@property (nonatomic, assign) CGFloat cornerRadius;
// 背景颜色
@property (nonatomic, strong) UIColor *backGroundColor;
// 透明度
@property (nonatomic, assign) CGFloat alpha;
// 创建单例
+ (ToastSetting *)instance;

@end