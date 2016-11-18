//
//  CustomScreenshot.m
//  Pods
//
//  Created by James Maxwell on 11/17/16.
//
//

#import "CustomScreenshot.h"


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
    //Get the screenshot first
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize imageSize = rect.size;
    
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
    
    [_customScreenshotDelegate screenshotReturned:processedImage];
}

-(UIImage *) getScreenshot {
    //Get the screenshot first
    // create graphics context with screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screengrab;
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
