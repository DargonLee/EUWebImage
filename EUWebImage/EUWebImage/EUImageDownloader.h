//
//  EUImageDownloader.h
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EUImageDownloader : NSObject

+ (instancetype)defaultInstance;

- (void)fetchImageWithUrl:(NSString *)url completion:(void(^)(UIImage *_Nullable image,NSError *_Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
