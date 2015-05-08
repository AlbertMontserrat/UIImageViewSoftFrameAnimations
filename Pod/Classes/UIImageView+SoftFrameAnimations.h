//
//  UIImageView+SoftFrameAnimations.h
//  benito
//
//  Created by Albert Montserrat on 09/05/13.
//  Copyright (c) 2013 Albert Montserrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoftFrameAnimationsDelegate;


@interface SoftFrameAnimationsWeakWrapper : NSObject
@property (nonatomic, weak, readonly) id weakObject;
- (id)initWithWeakObject:(id)weakObject;
@end


@interface UIImageView  (SoftFrameAnimations)


@property(nonatomic,assign) BOOL loopAnimation;
@property(nonatomic,assign) NSInteger loopcount;
@property(nonatomic,assign) NSInteger position;
@property(nonatomic,strong) NSString *imagename;
@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,assign) BOOL pause;
@property(nonatomic,assign) NSInteger numberOfDigits;
@property(nonatomic,assign) NSInteger firstdigit;
@property(nonatomic,strong) NSString *extension;
@property(nonatomic,assign) CGFloat fps;


@property(nonatomic,retain) NSString *idleimagename;
@property(nonatomic,assign) NSInteger idlenumberOfDigits;
@property(nonatomic,assign) NSInteger idlefirstdigit;
@property(nonatomic,strong) NSString *idleextension;
@property(nonatomic,assign) CGFloat idlefps;


@property(nonatomic,assign) NSInteger loops;
@property(nonatomic,assign) BOOL continuePlayingOnSetImage;
@property(nonatomic,retain) NSString *imageDisplayed;

@property(nonatomic,weak) id<SoftFrameAnimationsDelegate> delegate;

-(void)setIdleAnimation:(NSString *)idleAnimationName  numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext startNow:(BOOL)startNow andFPS:(CGFloat)framesPerSecond;
-(void)playIdle;
-(void)resumeIdle;
-(void)pauseIdle;
-(void)removeIdle;

-(void)softFrameAnimateWithImageName:(NSString *)imageName numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext loop:(BOOL)loop loopCount:(NSInteger)loopCount andFPS:(CGFloat)framesPerSecond;
-(void)pauseSoftFrameAnimation;
-(void)resumeSoftFrameAnimation;

-(void)setImagePath:(NSString *)image;
-(NSString *)getImageNameDisplayed;

+(UIImageView *)softFrameAnimateWithImageName:(NSString *)imageName numberOfDigits:(NSInteger)digits firstDigit:(NSInteger)firstDigit andExtension:(NSString *)ext loop:(BOOL)loop loopCount:(NSInteger)loopCount andFPS:(CGFloat)framesPerSecond inView:(UIView *)view inPoint:(CGPoint)center;



@end

@protocol SoftFrameAnimationsDelegate <NSObject>
@optional
-(void)softFrameAnimation:(UIImageView *)softFrameAnimationView didShowFrame:(NSInteger)frame;
-(void)softFrameAnimationDidEndLoop:(UIImageView *)softFrameAnimationView;
-(void)softFrameAnimationDidEndAnimation:(UIImageView *)softFrameAnimationView;
-(void)softFrameAnimation:(UIImageView *)softFrameAnimationView didSetImage:(NSString *)image;

@end
