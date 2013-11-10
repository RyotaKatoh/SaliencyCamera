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
    UIImage *saliencyImage;
    
    Saliency saliency;
    saliencyImage = saliency.getSaliencyMap(resultImage);
    
    if(fromCamera){
        UIImage *rotateImage;
        rotateImage = [UIImage imageWithCGImage:saliencyImage.CGImage scale:saliencyImage.scale orientation:UIImageOrientationRight];
        resultImageView.image = rotateImage;
    }
    else{
        
        resultImageView.image = saliencyImage;
    }
    [self hideActivityIndicator];
    
}

- (void)showActivityIndicator{

    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    
    //[self runCreatingSaliencyMap];
}

- (void)hideActivityIndicator{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

@end
