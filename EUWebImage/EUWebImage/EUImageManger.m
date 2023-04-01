//
//  EUImageManger.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "EUImageManger.h"

@implementation EUImageManger

+ (instancetype)shareManger
{
    static EUImageManger *__manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manger = [[self alloc]init];
    });
    return __manger;
}

@end
