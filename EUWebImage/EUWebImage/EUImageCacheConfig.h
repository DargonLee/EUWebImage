//
//  EUImageCacheConfig.h
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EUImageCacheConfig : NSObject

@property (nonatomic, assign) BOOL shouldCacheImagesInMemory;

@property (nonatomic, assign) BOOL shouldCacheImagesInDisk;

@property (nonatomic, assign) NSInteger maxCacheAge;

@property (nonatomic, assign) NSInteger maxCacheSize;



@end

NS_ASSUME_NONNULL_END
