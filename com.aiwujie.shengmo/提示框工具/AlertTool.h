//
//  AlertTool.h
//  圣魔无界
//
//  Created by 爱无界 on 2017/11/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertTool : NSObject
/**
 * 一般的正面弹框提示
 */
+(void)alertWithViewController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message;

@end
