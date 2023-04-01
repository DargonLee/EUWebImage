//
//  EUImageCacheManger.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "EUImageCacheManger.h"
#import <CommonCrypto/CommonDigest.h>

@interface EUImageCacheManger()

@property (nonatomic, strong) NSCache *imageMemoryCache;

@property (nonatomic, copy) NSString *diskCachePath;

@property (nonatomic, strong) NSFileManager *fileManger;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation EUImageCacheManger

- (NSCache *)imageMemoryCache
{
    if (!_imageMemoryCache) {
        _imageMemoryCache = [[NSCache alloc]init];
    }
    return _imageMemoryCache;
}

- (NSString *)diskCachePath
{
    if (!_diskCachePath) {
        _diskCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"com.euimage.cache"];
    }
    return _diskCachePath;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

+ (instancetype)defaultInstance
{
    static EUImageCacheManger *__cacheManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __cacheManger = [[self alloc]init];
    });
    return __cacheManger;
}

- (void)asyncQueryImageCacheForKey:(NSString *)key completionBlock:(void(^)(UIImage *_Nullable,EUImageCacheType))completionBlock
{
    if (!key || key.length == 0) {
        completionBlock(nil,EUImageCacheTypeNone);
        return;
    }
    void(^queryDiskBlock)(void) = ^ {
        // 从内存加载
        UIImage *memoryCache = [self.imageMemoryCache objectForKey:key];
        if (memoryCache) {
            NSLog(@"图片从内存中加载的");
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                completionBlock(memoryCache,EUImageCacheTypeMemory);
            }];
            return;
        }
        // 从硬盘加载
        NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data) {
            UIImage *diskImage = [UIImage imageWithData:data];
            if (diskImage) {// 存到内存中一份
                [self.imageMemoryCache setObject:diskImage forKey:key];
                
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    completionBlock(memoryCache,EUImageCacheTypeDisk);
                }];;
            }
        }
    };
    [_queue addOperationWithBlock:queryDiskBlock];
}

- (UIImage *_Nullable)syncQueryImageCacheForKey:(NSString *)key
{
    if (!key || key.length == 0) {
        return nil;
    }
    // 从内存加载
    UIImage *memoryCache = [self.imageMemoryCache objectForKey:key];
    if (memoryCache) {
        NSLog(@"图片从内存中加载的");
        return memoryCache;
    }
    // 从硬盘加载
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        UIImage *diskImage = [UIImage imageWithData:data];
        if (diskImage) {// 存到内存中一份
            [self.imageMemoryCache setObject:diskImage forKey:key];
            return diskImage;
        }
    }
    
    return nil;
}

- (void)storeImage:(UIImage *_Nullable)image forKey:(NSString *)key
{
    if (!image || !key || key.length == 0) {
        return;
    }
    [self.imageMemoryCache setObject:image forKey:key];
    [_queue addOperationWithBlock:^{
        NSData *data = nil;
        if ([self containAlphaWithCGimage:image.CGImage]) {
            data = UIImagePNGRepresentation(image);
        }else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        if (!data) {
            return;
        }
        if (![self.fileManger fileExistsAtPath:self.diskCachePath]) {
            [self.fileManger createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *cachePath = [self.diskCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
        NSURL *fileUrl = [NSURL fileURLWithPath:cachePath];
        [data writeToURL:fileUrl atomically:YES];// 存储到磁盘上
    }];
}

// MD5编码
- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key
{
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:key];
    NSString *ext = keyURL ? keyURL.pathExtension : key.pathExtension;
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
    return filename;
}

- (BOOL)containAlphaWithCGimage:(CGImageRef)imageRef
{
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaNoneSkipFirst || alphaInfo == kCGImageAlphaNoneSkipLast);
    return  hasAlpha;
}

@end
