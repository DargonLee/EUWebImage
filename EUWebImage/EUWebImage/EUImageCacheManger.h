//
//  EUImageCacheManger.h
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EUImageCacheType) {
    EUImageCacheTypeNone,
    EUImageCacheTypeMemory,
    EUImageCacheTypeDisk
};

@interface EUImageCacheManger : NSObject

+ (instancetype)defaultInstance;

- (void)asyncQueryImageCacheForKey:(NSString *)key completionBlock:(void(^)(UIImage *_Nullable,EUImageCacheType))completionBlock;

- (UIImage *_Nullable)syncQueryImageCacheForKey:(NSString *)key;

- (void)storeImage:(UIImage *_Nullable)image forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
