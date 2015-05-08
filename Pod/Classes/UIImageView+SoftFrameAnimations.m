//
//  UIImageView+SoftFrameAnimations.m
//  benito
//
//  Created by Albert Montserrat on 09/05/13.
//  Copyright (c) 2013 Albert Montserrat. All rights reserved.
//

#import "UIImageView+SoftFrameAnimations.h"
#import <objc/runtime.h>

@implementation SoftFrameAnimationsWeakWrapper
- (id)initWithWeakObject:(id)weakObject
{
    self = [super init];
    if (self){_weakObject = weakObject;}
    return self;
}
@end



@implementation UIImageView (SoftFrameAnimations)

#pragma mark - SoftFrameAnimations Idle

-(void)setIdleAnimation:(NSString *)idleAnimationName  numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext startNow:(BOOL)startNow andFPS:(CGFloat)framesPerSecond{
    self.idleimagename = idleAnimationName;
    self.idlenumberOfDigits = digits;
    self.idlefirstdigit = firstDigit;
    self.idleextension = ext;
    self.idlefps = framesPerSecond;
    if(startNow){
        [self softFrameAnimateWithImageName:self.idleimagename numberOfDigits:self.idlenumberOfDigits firstDigit:self.idlefirstdigit andExtension:self.idleextension loop:YES loopCount:0 andFPS:self.idlefps];
    }
}

-(void)playIdle{
    if(!self.idleimagename)
        return;
    
    [self softFrameAnimateWithImageName:self.idleimagename numberOfDigits:self.idlenumberOfDigits firstDigit:self.idlefirstdigit andExtension:self.idleextension loop:YES loopCount:0 andFPS:self.idlefps];
}

-(void)resumeIdle{
    if(!self.idleimagename)
        return;
    
    if([self.imagename isEqualToString:self.idleimagename]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopImages) object:nil];
        
        self.pause = NO;
        [self loopImages];
    }else{
        [self playIdle];
    }
}

-(void)pauseIdle{
    if(!self.idleimagename)
        return;
    
    if([self.imagename isEqualToString:self.idleimagename]){
        [self pauseSoftFrameAnimation];
    }
}

-(void)removeIdle{
    if(!self.idleimagename)
        return;
    
    if([self.imagename isEqualToString:self.idleimagename]){
        [self pauseSoftFrameAnimation];
    }
    self.idleimagename = nil;
}



#pragma mark - SoftFrameAnimations Soft animate

-(void)softFrameAnimateWithImageName:(NSString *)imageName numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext loop:(BOOL)loop loopCount:(NSInteger)loopCount andFPS:(CGFloat)framesPerSecond{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopImages) object:nil];
    
    [self softFrameAnimateWithImageName:imageName numberOfDigits:digits firstDigit:firstDigit andExtension:ext loop:loop loopCount:loopCount andFPS:framesPerSecond currLoop:1];
    
}


-(void)softFrameAnimateWithImageName:(NSString *)imageName numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext loop:(BOOL)loop loopCount:(NSInteger)loopCount andFPS:(CGFloat)framesPerSecond currLoop:(NSInteger)currLoop{
    
    self.loops = currLoop;
    
    self.imagename = imageName;
    self.numberOfDigits = digits;
    self.extension = ext;
    self.loopAnimation = loop;
    self.fps = framesPerSecond;
    self.firstdigit = firstDigit;
    self.position = self.firstdigit;
    self.loopcount = loopCount;
    self.startDate = [NSDate date];
    
    self.pause = NO;
    [self loopImages];
}

-(void)loopImages{
    if(self.pause){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopImages) object:nil];
        return;
    }
    
    NSDate *start = [NSDate date];
    
    NSString *format = [NSString stringWithFormat:@"%%@%%0%dd",(int)self.numberOfDigits];
    NSString *imageName = [NSString stringWithFormat:format,self.imagename,self.position];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:self.extension];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if(!img) {
        
        if(self.loopAnimation && self.position != self.firstdigit){
            if(self.loopcount>0 && self.loops >= self.loopcount){
                NSString *format = [NSString stringWithFormat:@"%%@%%0%dd",(int)self.numberOfDigits];
                NSString *imageName = [NSString stringWithFormat:format,self.imagename,self.firstdigit];
                NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:self.extension];
                
                UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
                if(img){
                    self.continuePlayingOnSetImage = YES;
                    [self setImage:img];
                    self.imageDisplayed = imagePath;
                    if(self.delegate!=nil){
                        if([self.delegate respondsToSelector:@selector(softFrameAnimation:didSetImage:)]){
                            [self.delegate softFrameAnimation:self didSetImage:imagePath];
                        }
                    }
                    self.continuePlayingOnSetImage = NO;
                }
                
                if(self.delegate!=nil){
                    if([self.delegate respondsToSelector:@selector(softFrameAnimationDidEndAnimation:)]){
                        [self.delegate softFrameAnimationDidEndAnimation:self];
                    }
                }
                
                self.imagename = nil;
                
                return;
            }
            
            if(self.delegate!=nil){
                if([self.delegate respondsToSelector:@selector(softFrameAnimationDidEndLoop:)]){
                    [self.delegate softFrameAnimationDidEndLoop:self];
                }
            }
            
            [self softFrameAnimateWithImageName:self.imagename numberOfDigits:self.numberOfDigits firstDigit:self.firstdigit andExtension:self.extension loop:self.loopAnimation loopCount:self.loopcount andFPS:self.fps currLoop:(self.loops+1)];
            return;
        }else{
            
            if(self.delegate!=nil){
                if([self.delegate respondsToSelector:@selector(softFrameAnimationDidEndAnimation:)]){
                    [self.delegate softFrameAnimationDidEndAnimation:self];
                }
            }
            
            self.imagename = nil;
            
            if(self.idleimagename){
                [self softFrameAnimateWithImageName:self.idleimagename numberOfDigits:self.idlenumberOfDigits firstDigit:self.idlefirstdigit andExtension:self.idleextension loop:YES loopCount:0 andFPS:self.idlefps];
            }
            
            return;
        }
    }
    self.continuePlayingOnSetImage = YES;
    [self setImage:img];
    self.imageDisplayed = imagePath;
    if(self.delegate!=nil){
        if([self.delegate respondsToSelector:@selector(softFrameAnimation:didSetImage:)]){
            [self.delegate softFrameAnimation:self didSetImage:imagePath];
        }
    }
    self.continuePlayingOnSetImage = NO;
    
    
    if(self.delegate!=nil){
        if([self.delegate respondsToSelector:@selector(softFrameAnimation:didShowFrame:)]){
            [self.delegate softFrameAnimation:self didShowFrame:self.position];
        }
    }
    
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:start];
    [self performSelector:@selector(loopImages) withObject:nil afterDelay:MAX(self.fps - interval, 0)];
    
    self.position ++;
}

-(void)pauseSoftFrameAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopImages) object:nil];
    
    self.pause = YES;
}

-(void)stopSoftFrameAnimation{
    if(!self.imagename)
        return;
    
    [self pauseSoftFrameAnimation];
    self.imagename = nil;
}

-(void)resumeSoftFrameAnimation{
    if(!self.imagename)
        return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopImages) object:nil];
    
    self.pause = NO;
    [self loopImages];
}


#pragma mark - SoftFrameAnimations Image setting

-(void)setImagePath:(NSString *)image{
    if(!self.continuePlayingOnSetImage){
        [self pauseSoftFrameAnimation];
    }
    self.imageDisplayed = image;
    [self setImage:[UIImage imageWithContentsOfFile:image]];
}


#pragma mark - SoftFrameAnimations Current image name

-(NSString *)getImageNameDisplayed{
    return self.imageDisplayed;
}


#pragma mark - SoftFrameAnimations Static image creation

+(UIImageView *)softFrameAnimateWithImageName:(NSString *)imageName numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext loop:(BOOL)loop loopCount:(NSInteger)loopCount andFPS:(CGFloat)framesPerSecond inView:(UIView *)view inPoint:(CGPoint)center{
    
    NSString *format = [NSString stringWithFormat:@"%%@%%0%dd",(int)digits];
    NSString *imageNameFirst = [NSString stringWithFormat:format,imageName,firstDigit];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameFirst ofType:ext];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if(!img)
        return nil;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2.0, img.size.height/2.0)];
    imageView.image = img;
    imageView.center = center;
    [view addSubview:imageView];
    [imageView softFrameAnimateWithImageName:imageName numberOfDigits:digits firstDigit:firstDigit andExtension:ext loop:loop loopCount:loopCount andFPS:framesPerSecond];
    
    return imageView;
    
}



#pragma mark - Getters and setters

const NSString *kdelegate = @"delegate";
- (id<SoftFrameAnimationsDelegate>)delegate{
    return [objc_getAssociatedObject(self, &kdelegate) weakObject];
}
- (void)setDelegate:(id<SoftFrameAnimationsDelegate>)delegate{
    objc_setAssociatedObject(self, &kdelegate, [[SoftFrameAnimationsWeakWrapper alloc] initWithWeakObject:delegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kimageDisplayed = @"imageDisplayed";
- (NSString *)imageDisplayed{
    return (NSString *)objc_getAssociatedObject(self, &kimageDisplayed);
}
- (void)setImageDisplayed:(NSString *)imageDisplayed{
    objc_setAssociatedObject(self, &kimageDisplayed, imageDisplayed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

const NSString *kcontinuePlayingOnSetImage = @"continuePlayingOnSetImage";
- (BOOL)continuePlayingOnSetImage{
    return [objc_getAssociatedObject(self, &kcontinuePlayingOnSetImage) boolValue];
}
- (void)setContinuePlayingOnSetImage:(BOOL)continuePlayingOnSetImage{
    objc_setAssociatedObject(self, &kcontinuePlayingOnSetImage, [NSNumber numberWithBool:continuePlayingOnSetImage],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kidlefps = @"idlefps";
- (CGFloat)idlefps{
    return [objc_getAssociatedObject(self, &kidlefps) floatValue];
}
- (void)setIdlefps:(CGFloat)idlefps{
    objc_setAssociatedObject(self, &kidlefps, [NSNumber numberWithFloat:idlefps],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kidleextension = @"idleextension";
- (NSString *)idleextension{
    return (NSString *)objc_getAssociatedObject(self, &kidleextension);
}
- (void)setIdleextension:(NSString *)idleextension{
    objc_setAssociatedObject(self, &kidleextension, idleextension, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

const NSString *kidlefirstdigit = @"idlefirstdigit";
- (NSInteger)idlefirstdigit{
    return [objc_getAssociatedObject(self, &kidlefirstdigit) integerValue];
}
- (void)setIdlefirstdigit:(NSInteger)idlefirstdigit{
    objc_setAssociatedObject(self, &kidlefirstdigit, [NSNumber numberWithInt:(int)idlefirstdigit],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kidlenumberOfDigits = @"idlenumberOfDigits";
- (NSInteger)idlenumberOfDigits{
    return [objc_getAssociatedObject(self, &kidlenumberOfDigits) integerValue];
}
- (void)setIdlenumberOfDigits:(NSInteger)idlenumberOfDigits{
    objc_setAssociatedObject(self, &kidlenumberOfDigits, [NSNumber numberWithInt:(int)idlenumberOfDigits],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kidleimagename = @"idleimagename";
- (NSString *)idleimagename{
    return (NSString *)objc_getAssociatedObject(self, &kidleimagename);
}
- (void)setIdleimagename:(NSString *)idleimagename{
    objc_setAssociatedObject(self, &kidleimagename, idleimagename, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

const NSString *kfps = @"fps";
- (CGFloat)fps{
    return [objc_getAssociatedObject(self, &kfps) floatValue];
}
- (void)setFps:(CGFloat)fps{
    objc_setAssociatedObject(self, &kfps, [NSNumber numberWithFloat:fps],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kextension = @"extension";
- (NSString *)extension{
    return (NSString *)objc_getAssociatedObject(self, &kextension);
}
- (void)setExtension:(NSString *)extension{
    objc_setAssociatedObject(self, &kextension, extension, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

const NSString *kfirstdigit = @"firstdigit";
- (NSInteger)firstdigit{
    return [objc_getAssociatedObject(self, &kfirstdigit) integerValue];
}
- (void)setFirstdigit:(NSInteger)firstdigit{
    objc_setAssociatedObject(self, &kfirstdigit, [NSNumber numberWithInt:(int)firstdigit],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *knumberOfDigits = @"numberOfDigits";
- (NSInteger)numberOfDigits{
    return [objc_getAssociatedObject(self, &knumberOfDigits) integerValue];
}
- (void)setNumberOfDigits:(NSInteger)numberOfDigits{
    objc_setAssociatedObject(self, &knumberOfDigits, [NSNumber numberWithInt:(int)numberOfDigits],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kpause = @"pause";
- (BOOL)pause{
    return [objc_getAssociatedObject(self, &kpause) boolValue];
}
- (void)setPause:(BOOL)pause{
    objc_setAssociatedObject(self, &kpause, [NSNumber numberWithBool:pause],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kstartDate = @"startDate";
- (NSDate *)startDate{
    return (NSDate *)objc_getAssociatedObject(self, &kstartDate);
}
- (void)setStartDate:(NSDate *)startDate{
    objc_setAssociatedObject(self, &kstartDate, startDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

const NSString *kposition = @"position";
- (NSInteger)position{
    return [objc_getAssociatedObject(self, &kposition) integerValue];
}
- (void)setPosition:(NSInteger)position{
    objc_setAssociatedObject(self, &kposition, [NSNumber numberWithInt:(int)position],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kloopcount = @"loopcount";
- (NSInteger)loopcount{
    return [objc_getAssociatedObject(self, &kloopcount) integerValue];
}
- (void)setLoopcount:(NSInteger)loopcount{
    objc_setAssociatedObject(self, &kloopcount, [NSNumber numberWithInt:(int)loopcount],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kloopAnimation = @"loopAnimation";
- (BOOL)loopAnimation{
    return [objc_getAssociatedObject(self, &kloopAnimation) boolValue];
}
- (void)setLoopAnimation:(BOOL)loopAnimation{
    objc_setAssociatedObject(self, &kloopAnimation, [NSNumber numberWithBool:loopAnimation],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kLoops = @"loops";
- (NSInteger)loops{
    return [objc_getAssociatedObject(self, &kLoops) integerValue];
}
- (void)setLoops:(NSInteger)loops{
    objc_setAssociatedObject(self, &kLoops, [NSNumber numberWithInt:(int)loops],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

const NSString *kImageName = @"imagename";
- (NSString *)imagename{
    return (NSString *)objc_getAssociatedObject(self, &kImageName);
}
- (void)setImagename:(NSString *)imagename{
    objc_setAssociatedObject(self, &kImageName, imagename, OBJC_ASSOCIATION_COPY_NONATOMIC);
}





@end
