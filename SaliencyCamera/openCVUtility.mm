//
//  openCVUtility.m
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/22.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import "openCVUtility.h"

/* 一旦領域分割はやめておく  */

Mat openCVUtility::getWatershedImage(const cv::Mat &inputImg){

    Mat markers(inputImg.size(), CV_32SC1, Scalar(0,0,0));
    Mat cvtInputImg(inputImg.size(), CV_8UC3, Scalar(0,0,0));
    
    if(inputImg.channels() > 3){
        
        /* convert input image to 3 channels */
        int fromTo[] = {0,0, 1,1, 2,2};
        mixChannels(&inputImg, 1, &cvtInputImg, 1, fromTo, 3);
    
    }
    
//    int seedRad = 20;
//    static int numSeed = 0;
//    int numMaker = 200;
//
//    
//    for(int i=0;i<numMaker;i++){
//        CvPoint pt;
//        numSeed ++;
//        pt = cvPoint(ofRandom(inputImg.cols), ofRandom(inputImg.rows));
//        cvCircle(&markers, pt, seedRad, cvScalarAll(numSeed),CV_FILLED, 8, 0);
//    }
    return markers;
}