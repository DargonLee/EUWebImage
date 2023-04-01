//
//  UIImage+EUFormat.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "UIImage+EUFormat.h"
#import <objc/runtime.h>

@implementation UIImage (EUFormat)

- (void)setImages:(NSArray *)images
{
    objc_setAssociatedObject(self, @selector(images), images, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)images
{
    NSArray *images = objc_getAssociatedObject(self, @selector(images));
    if ([images isKindOfClass:[NSArray class]]) {
        return  images;
    }
    return nil;
}

- (void)setImageFormat:(EUImageFormat)imageFormat
{
    objc_setAssociatedObject(self, @selector(imageFormat), @(imageFormat), OBJC_ASSOCIATION_ASSIGN);
}

- (EUImageFormat)imageFormat
{
    EUImageFormat format = EUImageFormatUndefined;
    NSNumber *value = objc_getAssociatedObject(self, @selector(imageFormat));
    if ([value isKindOfClass:[NSNumber class]]) {
        format = value.integerValue;
        return  format;
    }
    return  format;
}

- (void)setTotalTimes:(NSTimeInterval)totalTimes
{
    objc_setAssociatedObject(self, @selector(totalTimes), @(totalTimes), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)totalTimes
{
    NSTimeInterval duration = 0;
    NSNumber *value = objc_getAssociatedObject(self, @selector(totalTimes));
    if ([value isKindOfClass:[NSNumber class]]) {
        duration = value.doubleValue;
    }
    return duration;
}


@end
