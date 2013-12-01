//
//  ViewController.h
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "resultViewController.h"
#import "UIImage+Utility.h"

#include "Saliency.h"

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{

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
    
}

@property (assign, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) IBOutlet UIButton *shutterButton;


- (IBAction)executeSaliency:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)openPhotoLibrary:(id)sender;

@end
