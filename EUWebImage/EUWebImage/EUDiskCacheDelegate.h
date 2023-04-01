//
//  EUDiskCacheDelegate.h
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EUDiskCacheDelegate <NSObject>

- (void)storeImageData:(NSDate *_Nullable)imageData forKey:(NSString *_Nullable)key;

- (NSData *_Nullable)queryImageDataForKey:(NSString *_Nullable)key;

- (BOOL)removeImageDataForKey:(NSString *_Nullable)key;

- (BOOL)containImageDataForKey:(NSString *_Nullable)key;

- (void)clearDiskCache;

@optional
- (void)deleteOldFiles; //后台更新文件

@end

NS_ASSUME_NONNULL_END
