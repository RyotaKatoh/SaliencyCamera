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
    
    /* iAd */
    //adBanner.delegate = self;
    
    
    /* AdMob */
    //bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0.0, self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height -  50)];
    
    NSLog(@"size:%f, %f",self.view.bounds.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    bannerView.adUnitID = @"ca-app-pub-5314472979260723/8888397293";
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    //[bannerView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - bannerView.bounds.size.height/2)];
    
    [bannerView loadRequest:[GADRequest request]];

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
    

    
    Saliency saliency;
    resultImage = [resultImage resize:resultImageView.frame];
    
    if(fromCamera){

        //resultImage = [resultImage resize:resultImageView.frame];
        saliencyImage = saliency.getSaliencyImage(resultImage);
        
        
        resultImageView.image = saliencyImage;
    }
    else{
        saliencyImage = saliency.getSaliencyImage(resultImage);
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

#pragma mark Social Framework

- (void) postToTwitter{
    SLComposeViewController *slComposeViewControllse = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    //[slComposeViewControllse setInitialText:@"posted by Spite Camera"];
    [slComposeViewControllse addImage:saliencyImage];
    [self presentViewController:slComposeViewControllse animated:YES completion:nil];
    
    
}

- (void) postToFacebook{
    SLComposeViewController *slComposeViewControllse = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //[slComposeViewControllse setInitialText:@"posted by Spite Camera"];
    [slComposeViewControllse addImage:saliencyImage];
    [self presentViewController:slComposeViewControllse animated:YES completion:nil];
    
}

#pragma mark actionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            [self saveImageToPhotoLibrary:saliencyImage];
            
            break;
            
        case 1:
            [self postToTwitter];
            break;
            
        case 2:
            [self postToFacebook];
            break;
            
        default:
            break;
    }
}

#pragma mark IBAction

- (IBAction)saveImage:(id)sender {
    //[self saveImageToPhotoLibrary:saliencyImage];
    
    UIActionSheet *sheet = [[UIActionSheet alloc]init];
    
    sheet.delegate = self;
    
    [sheet addButtonWithTitle:@"Save to Camera Roll"];
    [sheet addButtonWithTitle:@"Twitter"];
    [sheet addButtonWithTitle:@"Facebook"];
    [sheet addButtonWithTitle:@"Cancel"];
    
    sheet.cancelButtonIndex = 3;
    [sheet showInView:self.view];

}

#pragma mark iAD

//- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//
//    adBanner.hidden = NO;
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//
//    adBanner.hidden = YES;
//}

@end
