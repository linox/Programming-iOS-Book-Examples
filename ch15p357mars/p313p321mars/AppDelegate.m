

#import "AppDelegate.h"

@implementation AppDelegate


CGImageRef flip (CGImageRef im) {
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}



#define which 1
// substitute "2" thru "9" for other examples
// iOS 5:
// added case "10" to illustrate use of a CIFilter
// added case "11" to illustrate image tiling
// added case "12" to illustrate image stretching

// try all examples with both single-resolution and double-resolution device
// the double-resolution Mars image has "2" in it so you can see when it is being used



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
    
    
    switch (which) {
        case 1:
        {
            UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mars.png"]];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 2:
        {
            // figure 15-1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height), NO, 0);
            [mars drawAtPoint:CGPointMake(0,0)];
            [mars drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 10: 
        {
            
            // NSLog(@"%@", [CIFilter filterNamesInCategories:nil]);
            // iOS 6 adds *many* more filters than iOS 5 had; the complete list is:
            
            /*
             CIAdditionCompositing,
             CIAffineClamp,
             CIAffineTile,
             CIAffineTransform,
             CIBarsSwipeTransition,
             CIBlendWithMask,
             CIBloom,
             CIBumpDistortion,
             CIBumpDistortionLinear,
             CICheckerboardGenerator,
             CICircleSplashDistortion,
             CICircularScreen,
             CIColorBlendMode,
             CIColorBurnBlendMode,
             CIColorControls,
             CIColorCube,
             CIColorDodgeBlendMode,
             CIColorInvert,
             CIColorMap,
             CIColorMatrix,
             CIColorMonochrome,
             CIColorPosterize,
             CIConstantColorGenerator,
             CICopyMachineTransition,
             CICrop,
             CIDarkenBlendMode,
             CIDifferenceBlendMode,
             CIDisintegrateWithMaskTransition,
             CIDissolveTransition,
             CIDotScreen,
             CIEightfoldReflectedTile,
             CIExclusionBlendMode,
             CIExposureAdjust,
             CIFalseColor,
             CIFlashTransition,
             CIFourfoldReflectedTile,
             CIFourfoldRotatedTile,
             CIFourfoldTranslatedTile,
             CIGammaAdjust,
             CIGaussianBlur,
             CIGaussianGradient,
             CIGlideReflectedTile,
             CIGloom,
             CIHardLightBlendMode,
             CIHatchedScreen,
             CIHighlightShadowAdjust,
             CIHoleDistortion,
             CIHueAdjust,
             CIHueBlendMode,
             CILanczosScaleTransform,
             CILightenBlendMode,
             CILightTunnel,
             CILinearGradient,
             CILineScreen,
             CILuminosityBlendMode,
             CIMaskToAlpha,
             CIMaximumComponent,
             CIMaximumCompositing,
             CIMinimumComponent,
             CIMinimumCompositing,
             CIModTransition,
             CIMultiplyBlendMode,
             CIMultiplyCompositing,
             CIOverlayBlendMode,
             CIPerspectiveTile,
             CIPerspectiveTransform,
             CIPerspectiveTransformWithExtent,
             CIPinchDistortion,
             CIPixellate,
             CIRadialGradient,
             CIRandomGenerator,
             CISaturationBlendMode,
             CIScreenBlendMode,
             CISepiaTone,
             CISharpenLuminance,
             CISixfoldReflectedTile,
             CISixfoldRotatedTile,
             CISmoothLinearGradient,
             CISoftLightBlendMode,
             CISourceAtopCompositing,
             CISourceInCompositing,
             CISourceOutCompositing,
             CISourceOverCompositing,
             CIStarShineGenerator,
             CIStraightenFilter,
             CIStripesGenerator,
             CISwipeTransition,
             CITemperatureAndTint,
             CIToneCurve,
             CITriangleKaleidoscope,
             CITwelvefoldReflectedTile,
             CITwirlDistortion,
             CIUnsharpMask,
             CIVibrance,
             CIVignette,
             CIVortexDistortion,
             CIWhitePointAdjust
*/

            
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CIImage* marsci = [[CIImage alloc] initWithCGImage:mars.CGImage];

            // make a checkerboard pattern
            CIFilter* check = [CIFilter filterWithName:@"CICheckerboardGenerator"
                                         keysAndValues:
                               @"inputWidth",
                               @(marsci.extent.size.width/2.0),
                               @"inputCenter",
                               [CIVector vectorWithX:0 Y:0],
                               nil];
            // pass mars image thru a hue adjustment filter
            CIFilter* hue = [CIFilter filterWithName:@"CIHueAdjust"
                                       keysAndValues:
                             kCIInputImageKey,
                             marsci,
                             @"inputAngle",
                             @1.0f,
                             nil];
            // combine the two using blend
            CIFilter* comp = [CIFilter filterWithName:@"CIDifferenceBlendMode"
                                        keysAndValues:
                              kCIInputBackgroundImageKey, hue.outputImage,
                              kCIInputImageKey, check.outputImage,
                              nil];
            
            // output to a CGImage and draw into interface
            CIContext* con = [CIContext contextWithOptions:nil];
            CGImageRef chim = [con createCGImage:comp.outputImage
                                        fromRect:marsci.extent];
            UIImage* mars2 = [UIImage imageWithCGImage:chim];
            CGImageRelease(chim);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:mars2];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 11: {
            // iOS 5 has efficient tiling
            // (by "efficient" I mean that this takes basically no more memory than the original image)
            
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            UIImage* marsTiled = [mars resizableImageWithCapInsets:UIEdgeInsetsZero];
            UIImageView* iv = [[UIImageView alloc] initWithFrame: CGRectMake(20,5,mars.size.width*2,mars.size.height*4)];
            iv.image = marsTiled;
            [self.window.rootViewController.view addSubview:iv];
            break;
        }
        case 12: {
            // stretching
            // uses new iOS 5 method rather than old method
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGFloat capw = mars.size.width / 2.0 - 1;
            CGFloat caph = mars.size.height / 2.0 - 1;
            UIImage* marsTiled = [mars resizableImageWithCapInsets:UIEdgeInsetsMake(caph, capw, caph, capw)];
            UIImageView* iv = [[UIImageView alloc] initWithFrame: CGRectMake(20,5,mars.size.width*2,mars.size.height*1.5)];
            iv.image = marsTiled;
            [self.window.rootViewController.view addSubview:iv];
            break;
        }
        case 3: 
        {
            // figure 15-2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height*2), NO, 0);
            [mars drawInRect:CGRectMake(0,0,sz.width*2,sz.height*2)];
            [mars drawInRect:CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height) 
                   blendMode:kCGBlendModeMultiply alpha:1.0];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 4:
        {
            // figure 15-3
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width/2.0, sz.height), NO, 0);
            [mars drawAtPoint:CGPointMake(-sz.width/2.0, 0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 5:
        {
            // figure 15-4
            // incorrectly flipped, doesn't work on double-resolution device
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft);
            CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight);
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 6:
        {
            // same as previous; flipping solution #1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft));
            CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight));
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 7:
        {
            // same as previous; flipping solution #2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            // extract each half as a CGImage
            CGSize sz = [mars size];
            CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage], 
                                                               CGRectMake(0,0,sz.width/2.0,sz.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage], 
                                                                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
            // draw each CGImage into an image context
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);
            // CGContextRef con = UIGraphicsGetCurrentContext();
            [[UIImage imageWithCGImage:marsLeft] drawAtPoint:CGPointMake(0,0)];
            [[UIImage imageWithCGImage:marsRight] drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 8:
        {
            // works on double-resolution device, flipping solution #1
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            // Derive CGImage and use its dimensions to extract its halves
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            // Use double-resolution graphics context if possible
            UIGraphicsBeginImageContextWithOptions(
                                                   CGSizeMake(sz.width*1.5, sz.height), NO, 0);
            // The rest is as before, calling flip() to compensate for flipping
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextDrawImage(
                               con, CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft));
            CGContextDrawImage(
                               con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight));
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
        }
        case 9:
        {
            // works on double-resolution device, flipping solution #2
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            // Derive CGImage and use its dimensions to extract its halves
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            // Use double-resolution graphics context if possible
            UIGraphicsBeginImageContextWithOptions(
                                                   CGSizeMake(sz.width*1.5, sz.height), NO, 0);
            [[UIImage imageWithCGImage:marsLeft 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(0,0)];
            [[UIImage imageWithCGImage:marsRight 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(sz.width,0)];
            UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            [self.window.rootViewController.view addSubview: iv];
            iv.center = self.window.center;
            break;
            
        }
    }

    
    
    
    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
