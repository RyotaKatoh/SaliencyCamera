//
//  resultViewController.h
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>
#import <iAd/iAd.h>
#include "Saliency.h"
#import "UIImage+Utility.h"
#import "GADBannerView.h"

@interface resultViewController : UIViewController<UIActionSheetDelegate, ADBannerViewDelegate>{

    UIImage *saliencyImage;
    
    GADBannerView *bannerView;
    
@public
    BOOL fromCamera;
}

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *resultImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveImageButton;


- (IBAction)saveImage:(id)sender;
@end
