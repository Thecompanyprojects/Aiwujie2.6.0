//
//  AlertTool.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/11/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "AlertTool.h"

@implementation AlertTool

/**
 * 一般的正面弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:action];
    
    [controller presentViewController:alert animated:YES completion:nil];
}


@end

