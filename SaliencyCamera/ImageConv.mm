//
//  ImageConv.mm
//  msgCom
//
//  Created by tomo on 9/8/13.
//
//

#import "ImageConv.h"

@implementation ImageConv

- (id)init
{
	self = [super init];
	if (self != nil) {

	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (cv::Mat)UIImageToCvMat:(const UIImage *)image
{
	DLOG(@"uitomat");

    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
	
	CGImageRef ref = image.CGImage;
	int width = CGImageGetWidth(ref);
	int height = CGImageGetHeight(ref);
	DLOG(@"width=%d, height=%d", width, height);
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
	
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
	
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
	
    return cvMat;
}

- (UIImage *)CvMatToUIImage:(const cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
	
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
		DLOG(@"GRAY");
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
		DLOG(@"RGB");
    }
	
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
	
	
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
	
	CGImageRef ref = finalImage.CGImage;
	int width = CGImageGetWidth(ref);
	int height = CGImageGetHeight(ref);
	DLOG(@"width=%d, height=%d", width, height);
	
    return finalImage;
}

@end

