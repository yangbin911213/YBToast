//
//  ViewController.m
//  YBToast
//
//  Created by yangbin on 16/10/20.
//  Copyright © 2016年 yangbin. All rights reserved.
//

#import "ViewController.h"
#import "Toast.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)toastClick:(id)sender {
    
    kToastSetting.toastGravity = ToastGravityCenter;
    kToastSetting.fontSize = 14;
    
    [[Toast instance] showWithText:@"我是toast提示！！！"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
