//
//  resultViewController.m
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import "resultViewController.h"

@interface resultViewController ()

@end

@implementation resultViewController
@synthesize resultImageView;
@synthesize resultImage;
@synthesize activityIndicator;
@synthesize saveImageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    saveImageButton.enabled = NO;
    [self showActivityIndicator];

}

- (void)viewDidAppear:(BOOL)animated{
    
        [self runCreatingSaliencyMap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runCreatingSaliencyMap{
    
//    Saliency saliency;
//    CGRect halfFrame = resultImageView.frame;
//    halfFrame.size.width = halfFrame.size.width / 2;
//    halfFrame.size.height= halfFrame.size.height/ 2;
//    UIImage *srcImage = [resultImage resize:halfFrame];
//    NSLog(@"srcSize: %f, %f", srcImage.size.width, srcImage.size.height);
//    
//    saliencyImage = saliency.getSaliencyMap(srcImage);
//    
//    //saliencyImage = [saliencyImage resize:resultImageView.frame];
//    NSLog(@"outSize: %f, %f", saliencyImage.size.width, saliencyImage.size.height);
    
    Saliency saliency;
    saliencyImage = saliency.getSaliencyMap(resultImage);

    if(fromCamera){
        //UIImage *rotateImage;
        saliencyImage = [UIImage imageWithCGImage:saliencyImage.CGImage scale:saliencyImage.scale orientation:UIImageOrientationRight];
        
        saliencyImage = [saliencyImage resize:resultImageView.frame];
        
        resultImageView.image = saliencyImage;
    }
    else{
        
        resultImageView.image = saliencyImage;
    }
    [self hideActivityIndicator];

}

#pragma mark ActivityIndicator

- (void)showActivityIndicator{

    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    
    //[self runCreatingSaliencyMap];
}

- (void)hideActivityIndicator{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    saveImageButton.enabled = YES;
}

#pragma mark saveImage

- (BOOL)isPhotoAccessEnableWithIsShowAlert: (BOOL)isShowAlert{

    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    BOOL isAuthorization = NO;
    
    switch (status) {
        case ALAuthorizationStatusAuthorized:
            isAuthorization = YES;
            break;
            
        case ALAuthorizationStatusNotDetermined:
            isAuthorization = YES;
            break;
            
        case ALAuthorizationStatusRestricted:
            isAuthorization = NO;
            
            if(isShowAlert){
            
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"Access to Photo Library is not authorized." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
                [alertView show];
            }
            
            break;
            
        case ALAuthorizationStatusDenied:
            isAuthorization = NO;
            if(isShowAlert){
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"Access to Photo Library is not authorized." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
            
            break;
            
        default:
            break;
    }
    
    return isAuthorization;
}

- (void)saveImageToPhotoLibrary:(UIImage *)image{

    BOOL isPhotoAccessEnable = [self isPhotoAccessEnableWithIsShowAlert:YES];
    
    if(isPhotoAccessEnable){
    
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        
        
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error){
        
            NSLog(@"URL:%@",assetURL);
            NSLog(@"error:%@",error);
            
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            
            if(status == ALAuthorizationStatusDenied){
            
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"Access to Photo Library is not authorized." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
            else{
            
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                
            }
        }];
    }
    
}

#pragma mark IBAction

- (IBAction)saveImage:(id)sender {
    [self saveImageToPhotoLibrary:saliencyImage];

}
@end
