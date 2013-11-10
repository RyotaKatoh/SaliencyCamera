//
//  resultViewController.h
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Saliency.h"

@interface resultViewController : UIViewController{

@public
    BOOL fromCamera;
}

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *resultImage;
@end
