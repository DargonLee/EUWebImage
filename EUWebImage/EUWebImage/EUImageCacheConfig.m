//
//  EUImageCacheConfig.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "EUImageCacheConfig.h"

static const NSInteger kDefaultMaxCacheAge = 60 * 60 * 24 * 7;

@implementation EUImageCacheConfig

- (instancetype)init
{
    if (self = [super init]) {
        self.shouldCacheImagesInDisk = YES;
        self.shouldCacheImagesInMemory = YES;
        self.maxCacheAge = kDefaultMaxCacheAge;
        self.maxCacheSize = NSUIntegerMax;
    }
    return self;
}

@end
