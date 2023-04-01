//
//  EUImageDownloader.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "EUImageDownloader.h"

@interface EUImageDownloader()

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation EUImageDownloader

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc]init];
    }
    return _cache;
}

+ (instancetype)defaultInstance
{
    static EUImageDownloader *__downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __downloader = [[self alloc]init];
    });
    return __downloader;
}

#pragma mark---------------------------Methods处理--------------------------------
- (void)fetchImageWithUrl:(NSString *)url completion:(void (^)(UIImage * _Nullable, NSError * _Nullable))completionBlock
{
    if (!url || url.length == 0) {
        return;
    }
    
    UIImage *cacheImage = [self.cache objectForKey:url];
    if (cacheImage) {
        NSLog(@"从内存中查找");
        completionBlock(cacheImage,nil);
        return;
    }
    
    NSURL *urlString = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithURL:urlString completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIImage *image = [UIImage imageWithData:data];
            [strongSelf.cache setObject:image forKey:url];
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"从网上下载");
                    completionBlock(image,nil);
                });
            }
        }
    }];
    [task resume];
}

@end
