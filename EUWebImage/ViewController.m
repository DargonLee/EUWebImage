//
//  ViewController.m
//  EUWebImage
//
//  Created by Harlans on 2019/4/11.
//  Copyright © 2019 Harlans. All rights reserved.
//

#import "ViewController.h"
#import "EUWebImage/EUImageDownloader.h"
#import "EUWebImage/UIImage+EUFormat.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downloadImage];
}

- (void)downloadImage
{
    NSString *imageUrl = @"https://user-gold-cdn.xitu.io/2019/3/25/169b406dfc5fe46e";
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            UIImage *image = [UIImage imageWithData:data];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.imageView.image = image;
                });
            }
        }
    }];
    [task resume];
}

- (void)downLoadGifImage
{
    NSString *imageUrl = @"https://user-gold-cdn.xitu.io/2019/3/25/169b406dfc5fe46e";
    __weak typeof(self) weakSelf = self;
    [[EUImageDownloader defaultInstance]fetchImageWithUrl:imageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (image && strongSelf) {
            if (image.imageFormat == EUImageFormatGIF) {
                strongSelf.imageView.animationImages = image.images;
                strongSelf.imageView.animationDuration = image.totalTimes;
                [strongSelf.imageView startAnimating];
            }else {
                strongSelf.imageView.image = image;
            }
        }
    }];
}


@end
