//
//  ViewController.h
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "resultViewController.h"
#import "UIImage+Utility.h"
#import "GADBannerView.h"

#include "Saliency.h"

//#define DEFINE_IPHONE_SIMULATOR

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,ADBannerViewDelegate>{

    BOOL isUsingFrontFacingCamera;
    BOOL isSelectedOpenCamera;
    BOOL isSelectedOpenPhotoLibrary;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureVideoDataOutput *videoDataOutput;
    dispatch_queue_t videoDataOutputQueue;
    
    CGFloat effectiveScale;
    UIView *previewView;
    
    UIImage *photoLibraryImage;
    
    //IBOutlet ADBannerView *adBanner;
    GADBannerView *bannerView;
}

@property (assign, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) IBOutlet UIButton *shutterButton;

- (IBAction)executeSaliency:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)openPhotoLibrary:(id)sender;

@end
