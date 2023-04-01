//
//  UIImage+EUFormat.h
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EUImageFormat){
    EUImageFormatJPEG,
    EUImageFormatPNG,
    EUImageFormatGIF,
    EUImageFormatUndefined
};

@interface UIImage (EUFormat)

@property (nonatomic, assign) EUImageFormat imageFormat;

@property (nonatomic, copy) NSArray *images;

@property (nonatomic, assign) NSTimeInterval totalTimes;


@end

NS_ASSUME_NONNULL_END
