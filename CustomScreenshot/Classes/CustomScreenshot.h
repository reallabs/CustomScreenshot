//
//  CustomScreenshot.h
//  Pods
//
//  Created by James Maxwell on 11/17/16.
//
//

#import <Foundation/Foundation.h>

@protocol CustomScreenshotDelegate <NSObject>

@optional
-(void)screenshotReturned:(UIImage *)image;
-(void)watermarkedScreenshotReturned:(UIImage *)image;

@end

@interface CustomScreenshot : NSObject

+ (id) sharedInstance;

- (void) setWatermarkImage:(UIImage *)watermarkImage watermarkFrame:(CGRect)watermarkFrame;

@property (nonatomic, readwrite, weak) id<CustomScreenshotDelegate> customScreenshotDelegate;

@end
