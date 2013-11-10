//
//  ImageConv.h
//  msgCom
//
//  Created by tomo on 9/8/13.
//
//

#import "SaliencyDef.h"

@interface ImageConv : NSObject
{
	
}

- (id)init;
- (void)dealloc;
- (cv::Mat)UIImageToCvMat:(const UIImage *)image;
- (UIImage *)CvMatToUIImage:(const cv::Mat)cvMat;

@end
