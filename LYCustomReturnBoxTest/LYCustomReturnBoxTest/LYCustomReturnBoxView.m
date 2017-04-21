//
//  LYCustomReturnBoxView.m
//  CustomLayoutTest
//
//  Created by li_yong on 16/3/2.
//  Copyright © 2016年 li_yong. All rights reserved.
//

#import "LYCustomReturnBoxView.h"

//#define DEBUGMODEL

//循环动画循环一次的动画时间
NSTimeInterval const kLYCRBVKeyFrameAnimationDuring = 5.0;
//动画缩放比例
CGFloat const kLYCRBVMinScale = 0.00;

@interface LYCustomReturnBoxView()

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//标签1
@property (strong, nonatomic) UILabel *label1;
//标签2
@property (strong, nonatomic) UILabel *label2;
//标签3
@property (strong, nonatomic) UILabel *label3;
//将要显示的标签
@property (strong, nonatomic) UILabel *showingLabel;

//定时器
@property (strong, nonatomic) NSTimer *timer;
//监听动画的定时器的时间间隔
@property (assign, nonatomic) NSTimeInterval timerDuring;

//标题序号
@property (assign, nonatomic) NSInteger titleIndex;

//滚动风格
@property (assign, nonatomic) ReturnBoxStyle returnBoxStyle;

@end

@implementation LYCustomReturnBoxView

#pragma mark - overwrite

- (void)dealloc
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  @author li_yong
 *
 *  初始化方法
 *
 *  @param frame
 *  @param returnBoxStyle 滚动风格
 *  @param dataSource     数据源(字符串/富文本)
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     returnBoxStyle:(ReturnBoxStyle)returnBoxStyle
         dataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        self.returnBoxStyle = returnBoxStyle;
        [self buildView];
    }
    return self;
}

#pragma mark - property

/**
 *  @author liyong
 *
 *  设置内容对齐方式
 *
 *  @param textAlignment
 */
- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if ((textAlignment != self.label1.textAlignment) &&
        (textAlignment != self.label2.textAlignment) &&
        (textAlignment != self.label3.textAlignment))
    {
        self.label1.textAlignment = textAlignment;
        self.label2.textAlignment = textAlignment;
        self.label3.textAlignment = textAlignment;
    }
}

/**
 *  @author liyong
 *
 *  设置内容字体大小(非富文本)
 *
 *  @param textFont
 */
- (void)setTextFont:(UIFont *)textFont
{
    self.label1.font = textFont;
    self.label2.font = textFont;
    self.label3.font = textFont;
}

/**
 *  @author liyong
 *
 *  设置内容字体颜色
 *
 *  @param textColor
 */
- (void)setTextColor:(UIColor *)textColor
{
    if ((textColor != self.label1.textColor) &&
        (textColor != self.label2.textColor) &&
        (textColor != self.label3.textColor))
    {
        self.label1.textColor = textColor;
        self.label2.textColor = textColor;
        self.label3.textColor = textColor;
    }
}

#pragma mark - func

/**
 *  @author liyong
 *
 *  构件界面
 */
- (void)buildView
{
    //标签1
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.textColor = [UIColor blackColor];
    self.label1.font = [UIFont systemFontOfSize:14];
#ifdef DEBUGMODEL
    self.label1.backgroundColor = [UIColor redColor];
#else
    self.label1.backgroundColor = [UIColor clearColor];
#endif
    if (self.titleIndex < [self.dataSource count])
    {
        [self addTextAtIndex:self.titleIndex++ ForLabel:self.label1];
    }
    [self addSubview:self.label1];
    
    //标签2
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = [UIColor blackColor];
    self.label2.font = [UIFont systemFontOfSize:14];
#ifdef DEBUGMODEL
    self.label2.backgroundColor = [UIColor greenColor];
#else
    self.label2.backgroundColor = [UIColor clearColor];
#endif
    self.label2.layer.transform = CATransform3DScale(self.label2.layer.transform, 1, 0, 1);
    self.label2.layer.position = CGPointMake(self.label2.layer.position.x, 0);
    [self addSubview:self.label2];
    
    //标签3
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.textColor = [UIColor blackColor];
    self.label3.font = [UIFont systemFontOfSize:14];
#ifdef DEBUGMODEL
    self.label3.backgroundColor = [UIColor blueColor];
#else
    self.label3.backgroundColor = [UIColor clearColor];
#endif
    self.label3.layer.transform = CATransform3DScale(self.label2.layer.transform, 1, 0, 1);
    self.label3.layer.position = CGPointMake(self.label3.layer.position.x, self.frame.size.height);
    [self addSubview:self.label3];
    
    [self startReturn];
}

/**
 *  @author liyong
 *
 *  为label添加标题
 *
 *  @param titleIndex 标题序号
 *  @param label      添加标题的label
 */
- (void)addTextAtIndex:(NSInteger)titleIndex ForLabel:(UILabel *)label
{
    id obj = [self.dataSource objectAtIndex:titleIndex];
    if ([obj isKindOfClass:[NSAttributedString class]])
    {
        label.attributedText = (NSAttributedString *)obj;
    }else if ([obj isKindOfClass:[NSString class]])
    {
        label.text = (NSString *)obj;
    }
}

/**
 *  @author li_yong
 *
 *  开始轮回旋转
 */
- (void)startReturn
{
    //缩放的动画帧变量
    NSValue *scaleMaxValue = @(1);
    NSValue *scaleMinValue = @(kLYCRBVMinScale);
    
    //移动的动画帧变量
    NSValue *translationTopValue = @(0.0);
    NSValue *translationCenterValue = @(self.frame.size.height / 2);
    NSValue *TranslationBottomValue = @(self.frame.size.height);
    
    switch (self.returnBoxStyle)
    {
        case ReturnBoxStyleCubeTopToBottom:
        {
            //标签1的缩放动画和移动动画
            [self addAnimationForLayer:self.label1.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMaxValue, scaleMaxValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMaxValue],
                                         @"position.y" : @[translationCenterValue, translationCenterValue, TranslationBottomValue,
                                                           TranslationBottomValue, translationTopValue,translationTopValue, translationCenterValue]}];
            //标签2的缩放和移动动画
            [self addAnimationForLayer:self.label2.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMinValue, scaleMinValue, scaleMaxValue, scaleMaxValue, scaleMinValue, scaleMinValue, scaleMinValue],
                                         @"position.y" : @[translationTopValue, translationTopValue, translationCenterValue,
                                                           translationCenterValue, TranslationBottomValue, TranslationBottomValue, translationTopValue]}];
            
            //标签3的缩放和移动动画
            [self addAnimationForLayer:self.label3.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMinValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMaxValue, scaleMaxValue, scaleMinValue],
                                         @"position.y" : @[TranslationBottomValue, TranslationBottomValue, translationTopValue,
                                                           translationTopValue, translationCenterValue, translationCenterValue,
                                                           TranslationBottomValue]}];
        }
            break;
        case ReturnBoxStyleCubeBottomToTop:
        {
            //标签1的缩放动画和移动动画
            [self addAnimationForLayer:self.label1.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMaxValue, scaleMaxValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMaxValue],
                                         @"position.y" : @[translationCenterValue, translationCenterValue, translationTopValue,
                                                           translationTopValue, TranslationBottomValue,TranslationBottomValue, translationCenterValue]}];
            
            //标签2的缩放和移动动画
            [self addAnimationForLayer:self.label2.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMinValue, scaleMinValue, scaleMinValue, scaleMinValue, scaleMaxValue, scaleMaxValue, scaleMinValue],
                                         @"position.y" : @[translationTopValue, translationTopValue, TranslationBottomValue,
                                                           TranslationBottomValue, translationCenterValue, translationCenterValue, translationTopValue]}];
            
            //标签3的缩放和移动动画
            [self addAnimationForLayer:self.label3.layer
                            configInfo:@{
                                         @"transform.scale.y" : @[scaleMinValue, scaleMinValue, scaleMaxValue, scaleMaxValue, scaleMinValue, scaleMinValue, scaleMinValue],
                                         @"position.y" : @[TranslationBottomValue, TranslationBottomValue, translationCenterValue,
                                                           translationCenterValue, translationTopValue, translationTopValue, TranslationBottomValue]}];
        }
            break;            
            
        default:
            break;
    }
    
    //定时器
    if ([self.label1.layer.animationKeys count] > 0)
    {
        NSString *animationKey = self.label1.layer.animationKeys[0];
        CAAnimation *animation = [self.label1.layer animationForKey:animationKey];
        if ([animation isKindOfClass:[CAKeyframeAnimation class]])
        {
            CAKeyframeAnimation *keyFrameAnimation = (CAKeyframeAnimation *)animation;
            if ([keyFrameAnimation.values count] > 0)
            {
                //计算定时器时间间隔
                self.timerDuring = kLYCRBVKeyFrameAnimationDuring / keyFrameAnimation.values.count;
            }
        }
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerDuring
                                                  target:self
                                                selector:@selector(listenerReturn)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  @author liyong
 *
 *  为图层添加动画
 *
 *  @param layer   图层
 *  @param infoDic 动画的帧配置文件
 */
- (void)addAnimationForLayer:(nullable CALayer *)layer
                  configInfo:(nullable NSDictionary <NSString *, NSArray *>*)infoDic
{
    [infoDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if (([key length] > 0) && ([obj count] > 0))
        {
            [self addAnimationForLayer:layer
                               keyPath:key
                                values:obj];
        }
    }];
}

/**
 *  @author liyong
 *
 *  为图层添加动画
 *
 *  @param layer   图层
 *  @param keyPath 动画keyPath
 *  @param values  动画的帧
 */
- (void)addAnimationForLayer:(nullable CALayer *)layer
                     keyPath:(nullable NSString *)keyPath
                      values:(nullable NSArray <NSValue *> *)values
{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    keyFrameAnimation.values = values;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    keyFrameAnimation.repeatCount = NSIntegerMax;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSString *animationKey = [NSString stringWithFormat:@"layer.%@", keyPath];
    [layer addAnimation:keyFrameAnimation forKey:animationKey];
}

/**
 *  @author liyong
 *
 *  启动转动
 */
- (void)resumeReturn
{
    [self resumeAnimationForLayer:self.label1.layer];
    [self resumeAnimationForLayer:self.label2.layer];
    [self resumeAnimationForLayer:self.label3.layer];
    
    if ([self.timer isValid])
    {
        self.timer.fireDate = [NSDate distantPast];
    }
}

/**
 *  @author liyong
 *
 *  启动layer的动画
 *
 *  @param layer
 */
-(void)resumeAnimationForLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

/**
 *  @author liyong
 *
 *  暂停转动
 */
- (void)pauseReturn
{
    //移除动画
    [self pauseAnimationForLayer:self.label1.layer];
    [self pauseAnimationForLayer:self.label2.layer];
    [self pauseAnimationForLayer:self.label3.layer];
    
    //暂停定时器
    if ([self.timer isValid])
    {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

/**
 *  @author liyong
 *
 *  暂停layer的动画
 *
 *  @param layer
 */
- (void)pauseAnimationForLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset =pausedTime;
}

/**
 *  @author liyong
 *
 *  跑马灯是否还在转动中
 *
 *  @return
 */
- (BOOL)isReturning
{
    if ((self.label1.layer.speed == 0) &&
        (self.label1.layer.speed == 0) &&
        (self.label1.layer.speed == 0))
    {
        return NO;
    }
    
    return YES;
}

/**
 *  @author liyong
 *
 *  监听动画，替换文案
 */
- (void)listenerReturn
{
    //标记将要显示的标签
    switch (self.returnBoxStyle)
    {
        case ReturnBoxStyleCubeTopToBottom:
        {
            if (([[self.label1.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                ([(CALayer *)(self.label1.layer.presentationLayer) position].y == 0) &&
                (CATransform3DEqualToTransform([(CALayer *)(self.label1.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label1;
            }else if (([[self.label2.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                      ([(CALayer *)(self.label2.layer.presentationLayer) position].y == 0) &&
                      (CATransform3DEqualToTransform([(CALayer *)(self.label2.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label2;
            }else if (([[self.label3.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                      ([(CALayer *)(self.label3.layer.presentationLayer) position].y == 0) &&
                      (CATransform3DEqualToTransform([(CALayer *)(self.label3.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label3;
            }else
            {
                self.showingLabel = nil;
            }
        }
            break;
        
        case ReturnBoxStyleCubeBottomToTop:
        {
            if (([[self.label1.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                ([(CALayer *)(self.label1.layer.presentationLayer) position].y == self.frame.size.height) &&
                (CATransform3DEqualToTransform([(CALayer *)(self.label1.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label1;
            }else if (([[self.label2.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                      ([(CALayer *)(self.label2.layer.presentationLayer) position].y == self.frame.size.height) &&
                      (CATransform3DEqualToTransform([(CALayer *)(self.label2.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label2;
            }else if (([[self.label3.layer presentationLayer] isKindOfClass:[CALayer class]]) &&
                      ([(CALayer *)(self.label3.layer.presentationLayer) position].y == self.frame.size.height) &&
                      (CATransform3DEqualToTransform([(CALayer *)(self.label3.layer.presentationLayer) transform], CATransform3DMakeScale(1, kLYCRBVMinScale, 1))))
            {
                self.showingLabel = self.label3;
            }else
            {
                self.showingLabel = nil;
            }
        }
            break;
            
        default:
        {
            self.showingLabel = nil;
        }
            break;
    }
    
    if (self.showingLabel != nil)
    {
        //设置将要显示的标签标题
        if (self.titleIndex >= [self.dataSource count])
        {
            if ([self.dataSource count] <= 1)
            {
                //数据源少于1，停止转动
                [self pauseReturn];
                return;
            }else{
                self.titleIndex = 0;
            }
        }
        [self addTextAtIndex:self.titleIndex++ ForLabel:self.showingLabel];
    }
}

/**
 *  @author li_yong
 *
 *  添加新数据
 *
 *  @param dataSource 新数据
 */
- (void)refreshWithDataSource:(NSArray *)dataSource
{
    //清空旧数据
    [self.dataSource removeAllObjects];
    //添加新数据
    [self.dataSource addObjectsFromArray:dataSource];
    //初始化titleIndex
    self.titleIndex = 0;
    if (![self isReturning])
    {
        [self resumeReturn];
    }
}

@end
