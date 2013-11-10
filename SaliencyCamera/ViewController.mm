//
//  ViewController.m
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/09.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;
@synthesize shutterButton;
@synthesize rotateCameraButton;
@synthesize openPhotoLibraryButton;

- (void)setButtonUI:(UIButton *)button{
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button.layer setBackgroundColor:[[UIColor orangeColor] CGColor]]; //背景色設定
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal]; //文字の影色設定
    button.titleLabel.shadowOffset = CGSizeMake( 1, 1 ); //影の位置設定
    [[button layer] setCornerRadius:button.frame.size.width/2];  //角丸設定
    [[button layer] setBorderColor:[[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] CGColor]];  //枠線色設定
    [[button layer] setBorderWidth:1.5f];  //枠線幅設定
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // set button UI
    [self setButtonUI:shutterButton];
    [self setButtonUI:rotateCameraButton];
    [self setButtonUI:openPhotoLibraryButton];
    
    //initialize
    isSelectedOpenPhotoLibrary = false;
    
    [self setupAVCapture];
    
}

- (void)dealloc{

    [super dealloc];
    
    [stillImageOutput release];
    [previewLayer release];
    [videoDataOutput release];
    [previewLayer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

- (void) setupAVCapture{
    
    NSError *error = nil;
    
    //AVCaptureSession *session = [AVCaptureSession new];
    AVCaptureSession *session = [AVCaptureSession new];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    if(!isUsingFrontFacingCamera){
        isUsingFrontFacingCamera = NO;
        
    }
    
    // select a video device, make an input
    AVCaptureDevice *device;
    
    if(isUsingFrontFacingCamera)
        device = [self frontFacingCameraIfAvailable];
    else
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //require( error == nil, bail);
    
    
    //if([session canAddInput:deviceInput])
    //    [session addInput:deviceInput];
    
    // make a still image output
    stillImageOutput = [AVCaptureStillImageOutput new];
    if([session canAddOutput:stillImageOutput])
        [session addOutput:stillImageOutput];
    
    // make a video data output
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // Create BGRA data. because both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if([session canAddOutput:videoDataOutput])
        [session addOutput:videoDataOutput];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo]setEnabled:NO];
    
    effectiveScale = 1.0;
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor]CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [[previewLayer session]addInput:deviceInput];
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    
    
    //    testString = [UIImage imageNamed:@"Default-568h@2x.png"];
    //    NSLog(@"av:%f, %f",testString.size.width, testString.size.height);
    
    [session startRunning];
    
    
bail:
    [session release];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int) [error code]] message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [self tearDownAVCapture];
    }
    
}

// clean up capture setup
- (void)tearDownAVCapture{
    
    [videoDataOutput release];
    if(videoDataOutputQueue)
        dispatch_release(videoDataOutputQueue);
    
    [stillImageOutput release];
    [previewLayer removeFromSuperlayer];
    [previewLayer release];
}


#pragma mark openCamera


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    switch(buttonIndex){
        case 0:
            isSelectedOpenCamera = true;
            
            [self tearDownAVCapture];
            
            [self openCamera];
            break;
        case 1:
            
            [self openPhotoLibrary];
            break;
            
        default:
            return;
            
    }
    
}

- (void)openCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [imagePickerController setAllowsEditing:NO];
        [imagePickerController setDelegate:self];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        
        
    }
    else{
        NSLog(@"camera invalid");
    }
    
}

- (void)openPhotoLibrary{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setAllowsEditing:NO];
        [imagePickerController setDelegate:self];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    else{
        
        NSLog(@"photo library invalid");
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    UIImage *libraryImage;
//    
//    libraryImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    float widthPer = libraryImage.size.width / previewView.frame.size.width;
//    float heightPer= libraryImage.size.height / previewView.frame.size.height;
//    float resizePer= max(widthPer, heightPer);
//    
//    CGSize sz = CGSizeMake(libraryImage.size.width*resizePer,libraryImage.size.height*resizePer);
//    UIGraphicsBeginImageContext(sz);
//    [libraryImage drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
//    photoLibraryImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    photoLibraryImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    isSelectedOpenPhotoLibrary = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if(isSelectedOpenCamera){
        [self setupAVCapture];
        
        isSelectedOpenCamera = false;
    }
    
//    [libraryImage release];
    
    [self performSegueWithIdentifier:@"takePhoto" sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(isSelectedOpenCamera){
        [self setupAVCapture];
        
        isSelectedOpenCamera = false;
    }
}

- (void)switchCamera{
    
    AVCaptureDevicePosition desiredPosition;
    if(isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for(AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]){
        
        if([d position] == desiredPosition){
            
            [[previewLayer session]beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for(AVCaptureInput *oldInput in [[previewLayer session] inputs]){
                
                [[previewLayer session]removeInput:oldInput];
            }
            [[previewLayer session] addInput:input];
            [[previewLayer session]commitConfiguration];
            break;
            
        }
        
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

#pragma mark captureOutput

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // write something code.
        imageView.image = image;
        
    });
    
    
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height= CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(newContext);
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    
    return image;
}

#pragma mark SEGUE

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"takePhoto"]){
    
        resultViewController *resultView = (resultViewController *)[segue destinationViewController];
        
        UIImage *cameraImage;
        
        if(isSelectedOpenPhotoLibrary){
            cameraImage = photoLibraryImage;
            
            isSelectedOpenPhotoLibrary = NO;
            resultView->fromCamera = NO;
            
        }
        else{
            cameraImage = imageView.image;
            resultView->fromCamera = YES;
        }
        
        resultView.resultImage = cameraImage;

    }
}


#pragma mark IBAction

- (IBAction)executeSaliency:(id)sender {
    
    [self performSegueWithIdentifier:@"takePhoto" sender:self];
    
}

- (IBAction)rotateCamera:(id)sender {
    [self switchCamera];
}

- (IBAction)openPhotoLibrary:(id)sender {
    [self openPhotoLibrary];
}


@end
