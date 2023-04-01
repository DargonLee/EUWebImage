//
//  EUImageCoder.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "EUImageCoder.h"
#import "UIImage+EUFormat.h"

#define kAnimatedImageDefaultDelayTimeInterval 0.01

@implementation EUImageCoder

- (UIImage *)decodeImageWithData:(NSData *)data
{
    EUImageFormat format = [self imageFormatWithData:data];
    switch (format) {
        case EUImageFormatJPEG:
        case EUImageFormatPNG:{
            UIImage *image = [[UIImage alloc]initWithData:data];
            return image;
        }
            break;
        case EUImageFormatGIF:{
            return [self decodeGIFWithData:data];
        }
            break;
        default:
            return nil;
            break;
    }
}

- (UIImage *)decodeGIFWithData:(NSData *)data
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return nil;
    }
    
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    NSTimeInterval duration = 0;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
        animatedImage.imageFormat = EUImageFormatGIF;
    } else {
        NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];
        for (size_t i = 0; i < count; i ++) {
            
            // 计算gif 每帧图片
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!imageRef) {
                continue;
            }
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            [imageArray addObject:image];
            CGImageRelease(imageRef);
            
            // 计算动画延时时间
            float delayTime = kAnimatedImageDefaultDelayTimeInterval;
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            if (properties) {
                CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                if (gif) {
                    CFTypeRef value = CFDictionaryGetValue(gif, kCGImagePropertyGIFUnclampedDelayTime);
                    if (!value) {
                        value = CFDictionaryGetValue(gif, kCGImagePropertyGIFDelayTime);
                    }
                    if (value) {
                        CFNumberGetValue(value, kCFNumberFloatType, &delayTime);
                    }
                }
                CFRelease(properties);
            }
            duration += delayTime;
            
        }
        animatedImage = [[UIImage alloc] init];
        animatedImage.imageFormat = EUImageFormatGIF;
        animatedImage.totalTimes = duration;
        animatedImage.images = [imageArray copy];
    }
    CFRelease(source);
    return animatedImage;
    
}


- (EUImageFormat)imageFormatWithData:(NSData *)data
{
    if (!data) {
        return EUImageFormatUndefined;
    }
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return EUImageFormatJPEG;
        case 0x89:
            return EUImageFormatPNG;
        case 0x47:
            return EUImageFormatGIF;
        default:
            return EUImageFormatUndefined;
    }
}


/*
 
 // 计算动画执行次数
 NSInteger loopCount = 0;
 CFDictionaryRef properties = CGImageSourceCopyProperties(source, NULL);
 if (properties) {
 CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
 if (gif) {
 CFTypeRef loop = CFDictionaryGetValue(gif, kCGImagePropertyGIFLoopCount);
 if (loop) {
 CFNumberGetValue(loop, kCFNumberNSIntegerType, &loopCount);
 }
 }
 CFRelease(properties); //注意使用完需要释放
 */

@end
