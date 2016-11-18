//
//  CSViewController.m
//  CustomScreenshot
//
//  Created by JJ Maxwell on 11/17/2016.
//  Copyright (c) 2016 JJ Maxwell. All rights reserved.
//

#import "CSViewController.h"

@interface CSViewController ()

@property (nonatomic, strong) UIImageView *screenshotView;

@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat watermarkWidth = rect.size.width / 4;
    CGFloat watermarkHeight = rect.size.height / 4;
    
    CGRect screenshotRect = CGRectMake((rect.size.width / 2)  - (watermarkWidth / 2), rect.size.height - watermarkHeight, watermarkWidth, watermarkHeight);
    
    CustomScreenshot *customScreenshot = [CustomScreenshot sharedInstance];
    customScreenshot.customScreenshotDelegate = self;
    [customScreenshot setWatermarkImage:[UIImage imageNamed:@"nfx.png"] watermarkFrame:screenshotRect];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:rect];
    backgroundView.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:backgroundView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)screenshotReturned:(UIImage *)image {
    [_screenshotView removeFromSuperview];
    _screenshotView = [[UIImageView alloc] initWithFrame:
                       CGRectMake(image.size.width / 4,
                                  image.size.height / 4,
                                  image.size.width / 2,
                                  image.size.height / 2)];
    _screenshotView.image = image;
    
    [self.view addSubview:_screenshotView];
    
}

-(void)watermarkedScreenshotReturned:(UIImage *)image {
    [_screenshotView removeFromSuperview];
    _screenshotView = [[UIImageView alloc] initWithFrame:
                       CGRectMake(image.size.width / 4,
                                  image.size.height / 4,
                                  image.size.width / 2,
                                  image.size.height / 2)];
    _screenshotView.image = image;
    
    [self.view addSubview:_screenshotView];
    
}


@end
