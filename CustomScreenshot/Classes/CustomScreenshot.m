//
//  CustomScreenshot.m
//  Pods
//
//  Created by James Maxwell on 11/17/16.
//
//

#import "CustomScreenshot.h"
OBJC_EXTERN UIImage *_UICreateScreenUIImage(void);

@interface CustomScreenshot () {}

@property (nonatomic, strong) UIImage *watermarkImage;
@property CGRect watermarkFrame;

@end


@implementation CustomScreenshot


+ (id)sharedInstance {
    static CustomScreenshot *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    id toRet = [super init];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationUserDidTakeScreenshotNotification
     object:nil
     queue:mainQueue
     usingBlock:^(NSNotification *note) {
         [self handleScreeshot:note];
     }];
    
    return toRet;
}

- (void) setWatermarkImage:(UIImage *)watermarkImage watermarkFrame:(CGRect)watermarkFrame {
    self.watermarkImage = watermarkImage;
    self.watermarkFrame = watermarkFrame;
}


-(void) handleScreeshot:(NSNotification *)note {
    if(self.watermarkImage) {
        [self returnScreenshotWithWatermark];
    } else {
        [self returnScreenshot];
    }
}


-(void) returnScreenshot {
    //Get the screenshot first
    UIImage *screenshotImage = [self getScreenshot];
    [_customScreenshotDelegate screenshotReturned:screenshotImage];
}


-(void) returnScreenshotWithWatermark {
    //Get the screenshot first
    
    UIImage *screenshotImage = [self getScreenshot];
    UIImage *processedImage = [self addWatermark:self.watermarkImage toImage:screenshotImage];
    
    [_customScreenshotDelegate watermarkedScreenshotReturned:processedImage];
}

-(UIImage *) getScreenshot {
    return _UICreateScreenUIImage();
}


-(UIImage *) addWatermark:(UIImage *)watermarkImage toImage:(UIImage *)screenshotImage {
    
    UIGraphicsBeginImageContext(screenshotImage.size);
    [screenshotImage drawInRect:CGRectMake(0, 0, screenshotImage.size.width, screenshotImage.size.height)];
    
    //A a scale factor for 1/6 of the width of the screen
    
    [watermarkImage drawInRect:self.watermarkFrame];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
}


@end
