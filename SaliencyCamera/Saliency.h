//
//  Saliency.h
//  msgCom
//
//  Created by tomo on 9/8/13.
//
//

#ifndef _Saliency_H
#define _Saliency_H

#include "SaliencyDef.h"
#include "Segmentation/segment-image.h"
#import "ImageConv.h"
#include "openCVtypes_c.h"
#include "Labeling.h"

#define PI 6*asin( 0.5 )

using namespace cv;

class Saliency
{
public:
	Saliency();
	~Saliency();

    // Get Labeling Image
    static Mat getSingleAreaSaliencyMap(const Mat &img3f);
	UIImage *getSaliencyImage(const UIImage *srcImage);
    
	// Get saliency values of a group of images.
	// Input image names and directory name for saving saliency maps.
	UIImage* getSaliencyMap(const UIImage *srcImage);
    Mat getSaliencyMapMat(const UIImage *srcImage,float resizeRate);
    
    // OutputImageFilter
    Mat runWhiteFilter(const Mat &img3f,const Mat saliencyMap, float resizeRate);
    Mat runMozicFilter(const Mat &img3f,const Mat saliencyMap, float resizeRate);
    Mat runChaosFilter(const Mat &img3f, const Mat saliencyMap, float resizeRate);
    Mat runSinFilter(const Mat &img3f, const Mat saliencyMap, float resizeRate);
	
	// Frequency Tuned [1].
	static Mat GetFT(const Mat &img3f);
	
	// Histogram Contrast of [3]
	static Mat GetHC(const Mat &img3f);
	
	// Region Contrast
	static Mat GetRC(const Mat &img3f);
	static Mat GetRC(const Mat &img3f, double sigmaDist, double segK, int segMinSize, double segSigma);
	
	// Luminance Contrast [2]
	static Mat GetLC(const Mat &img3f);
	
	// Spectral Residual [4]
	static	Mat GetSR(const Mat &img3f);
	
	// Color quantization
	static int Quantize(const Mat& img3f, Mat &idx1i, Mat &_color3f, Mat &_colorNum, double ratio = 0.95);
	
private:
	static const int SAL_TYPE_NUM = 5;
	typedef Mat (*GET_SAL_FUNC)(const Mat &);
	static const char* SAL_TYPE_DES[SAL_TYPE_NUM];
	static const GET_SAL_FUNC gFuns[SAL_TYPE_NUM];
	
	// Histogram based Contrast
	static void GetHC(const Mat &binColor3f, const Mat &weights1f, Mat &colorSaliency);
	
	static void Evaluate(const string& resultW, const string &gtImgW, vecD &precision, vecD &recall);
	static int PrintVector(FILE *f, const vecD &v, const string &name, int maxNum = 1000);
	
	static void SmoothSaliency(const Mat &binColor3f, Mat &sal1d, float delta, const vector<vector<CostfIdx> > &similar);
	
	static void AbsAngle(const Mat& cmplx32FC2, Mat& mag32FC1, Mat& ang32FC1);
	static void GetCmplx(const Mat& mag32F, const Mat& ang32F, Mat& cmplx32FC2);
	
	
	struct Region{
		Region() { pixNum = 0;}
		int pixNum;  // Number of pixels
		vector<CostfIdx> freIdx;  // Frequency of each color and its index
		Point2d centroid;
	};
	static void BuildRegions(const Mat& regIdx1i, vector<Region> &regs, const Mat &colorIdx1i, int colorNum);
	static void RegionContrast(const vector<Region> &regs, const Mat &color3fv, Mat& regSal1d, double sigmaDist);
};

#endif /* _Saliency_H */
