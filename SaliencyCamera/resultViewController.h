//
//  resultViewController.h
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include "Saliency.h"
#import "UIImage+Utility.h"

@interface resultViewController : UIViewController{

    UIImage *saliencyImage;
@public
    BOOL fromCamera;
}

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *resultImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveImageButton;


- (IBAction)saveImage:(id)sender;
@end
