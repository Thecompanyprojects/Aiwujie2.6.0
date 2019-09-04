//
//  LDAFManager.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/8/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAFManager.h"

@implementation LDAFManager

+ (AFHTTPSessionManager *)sharedManager {
    
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    });
    
    return manager;
}

@end
