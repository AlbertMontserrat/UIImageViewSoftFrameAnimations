# UIImageViewSoftFrameAnimations

[![CI Status](http://img.shields.io/travis/Albert M/UIImageViewSoftFrameAnimations.svg?style=flat)](https://travis-ci.org/Albert M/UIImageViewSoftFrameAnimations)
[![Version](https://img.shields.io/cocoapods/v/UIImageViewSoftFrameAnimations.svg?style=flat)](http://cocoapods.org/pods/UIImageViewSoftFrameAnimations)
[![License](https://img.shields.io/cocoapods/l/UIImageViewSoftFrameAnimations.svg?style=flat)](http://cocoapods.org/pods/UIImageViewSoftFrameAnimations)
[![Platform](https://img.shields.io/cocoapods/p/UIImageViewSoftFrameAnimations.svg?style=flat)](http://cocoapods.org/pods/UIImageViewSoftFrameAnimations)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

UIImageViewSoftFrameAnimations is a powerfull framework to run frame animations without having to load all images in memory at the beginning of the animation.
You just have to provide the name of the sequense, the numbero of digits of the sequence and the starting number. With this, the frameworks does everything.

The main function is the following:

```
-(void)softFrameAnimateWithImageName:(NSString *)imageName 
                      numberOfDigits:(NSInteger)digits 
                          firstDigit:(NSInteger)firstDigit 
                        andExtension:(NSString *)ext 
                                loop:(BOOL)loop 
                           loopCount:(NSInteger)loopCount 
                              andFPS:(CGFloat)framesPerSecond;
```

If we take as an example the following frames:
bird_01.jpg
bird_02.jpg
bird_03.jpg
bird_04.jpg
...
bird_13.jpg
bird_14.jpg

`imageName` is the bird_ part

`digits` is 2 because there are only two digits in all the sequence frames.

`firstDigit` is 1

`ext` is jpg without the point

`loop` will determine if the animation will loop. 

`loopCount` if you have specified loop = YES, loopCount will be the number of times that the animation will be reproduced. If loop is NO, this parameter will be ignored.

`framesPerSecond` is the speed of the animation


If you want to play an animation only one time, you can achieve this in two ways:

1 - loop = NO

2 - loop = YES and loopCount = 1

The two ways make differents things. The first one will reproduce the animation once and it will leave the last frame as final image. The second one will leave the first frame as the final image. It will give you the opportunity to achieve different animations only changing two parameters.


You can pause the animation at anytime:

```
-(void)pauseSoftFrameAnimation;
```

And resume it:

```
-(void)resumeSoftFrameAnimation;
```


- Idle animations

The framework gives the capacity to play idle animations:

```
-(void)setIdleAnimation:(NSString *)idleAnimationName  
         numberOfDigits:(NSInteger)digits 
             firstDigit:(NSInteger)firstDigit 
           andExtension:(NSString *)ext 
               startNow:(BOOL)startNow 
                 andFPS:(CGFloat)framesPerSecond;
```

You can configure an idle image and specify if you want to play it now or not.

When the idle image is setted and you play a softFrameAnimation with loop = NO, when the animation has ended, the idle animation will continue playing.

You can always play the idle manually:

```
-(void)playIdle;
```

And also remove the idle

```
-(void)removeIdle;
```


- Dynamic animations

As an additive, the framework give you the oportunity to create and add an animation into a view with one single line of code:

```
+(UIImageView *)softFrameAnimateWithImageName:(NSString *)imageName 
                               numberOfDigits:(NSInteger)digits 
                                   firstDigit:(NSInteger)firstDigit 
                                 andExtension:(NSString *)ext 
                                         loop:(BOOL)loop 
                                    loopCount:(NSInteger)loopCount 
                                       andFPS:(CGFloat)framesPerSecond 
                                       inView:(UIView *)view 
                                      inPoint:(CGPoint)center;
```

With the delegates you can know when the animation has ended and remove the UIImageView from the view if you want.


- Delegates

The framework also provides some delegates where you can listen for some events:

```
-(void)softFrameAnimation:(UIImageView *)softFrameAnimationView didShowFrame:(NSInteger)frame;
-(void)softFrameAnimationDidEndLoop:(UIImageView *)softFrameAnimationView;
-(void)softFrameAnimationDidEndAnimation:(UIImageView *)softFrameAnimationView;
-(void)softFrameAnimation:(UIImageView *)softFrameAnimationView didSetImage:(NSString *)image;
```

Enjoy!

## Requirements

## Installation

UIImageViewSoftFrameAnimations is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UIImageViewSoftFrameAnimations"
```

## Author

Albert Montserrat, albert.montserrat.gambus@gmail.com

## License

UIImageViewSoftFrameAnimations is available under the MIT license. See the LICENSE file for more info.
