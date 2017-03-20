//
//  LYCustomReturnBoxView.m
//  CustomLayoutTest
//
//  Created by li_yong on 16/3/2.
//  Copyright © 2016年 li_yong. All rights reserved.
//

#import "LYCustomReturnBoxView.h"

#define TIMER_DURING    2

#define ANIMATE_DURING  1

NSTimeInterval const kLYCRBVKeyFrameAnimationDuring = 3;
CGFloat const kLYCRBVMinScale = 0;

@interface LYCustomReturnBoxView()<CAAnimationDelegate>

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//标签1
@property (strong, nonatomic) UILabel *label1;
//标签2
@property (strong, nonatomic) UILabel *label2;

//将要显示的标签
@property (strong, nonatomic) UILabel *showingLabel;
//将要隐藏的标签
@property (strong, nonatomic) UILabel *hiddingLabel;

//定时器
@property (strong, nonatomic) NSTimer *timer;

//标题序号
@property (assign, nonatomic) NSInteger titleIndex;

//翻转的方式
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
 *  @param returnBoxStyle 翻转方式
 *  @param dataSource     数据源
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
              style:(ReturnBoxStyle)returnBoxStyle
         DataSource:(NSArray<NSString *> *)dataSource
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
        (textAlignment != self.label2.textAlignment))
    {
        self.label1.textAlignment = textAlignment;
        self.label2.textAlignment = textAlignment;
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
        (textColor != self.label2.textColor))
    {
        self.label1.textColor = textColor;
        self.label2.textColor = textColor;
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
    self.label1.backgroundColor = [UIColor blueColor];
    if (self.titleIndex < [self.dataSource count])
    {
        [self setTextAtIndex:self.titleIndex++ ForLabel:self.label1];
    }
    [self addSubview:self.label1];
    
    CAKeyframeAnimation *label1ScaleKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    NSValue *label1ScaleValue0 = @(1);
    NSValue *label1ScaleValue1 = @(kLYCRBVMinScale);
    NSArray *label1ScaleValueArray = @[label1ScaleValue0, label1ScaleValue1, label1ScaleValue1, label1ScaleValue0];
    label1ScaleKeyFrameAnimation.values = label1ScaleValueArray;
    label1ScaleKeyFrameAnimation.delegate = self;
    label1ScaleKeyFrameAnimation.removedOnCompletion = NO;
    label1ScaleKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label1ScaleKeyFrameAnimation.repeatCount = NSIntegerMax;
    [self.label1.layer addAnimation:label1ScaleKeyFrameAnimation forKey:@"self.label1.scaleKeyFrameAnimation"];
    
    CAKeyframeAnimation *label1TranslationKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    NSValue *label1TranslationValue0 = [NSNumber numberWithFloat:self.frame.size.height / 2];
    NSValue *label1TranslationValue1 = [NSNumber numberWithFloat:self.frame.size.height];
    NSValue *label1TranslationValue2 = [NSNumber numberWithFloat:0];
    NSArray *label1TranslationValueArray = @[label1TranslationValue0, label1TranslationValue1, label1TranslationValue2, label1TranslationValue0];
    label1TranslationKeyFrameAnimation.values = label1TranslationValueArray;
    label1TranslationKeyFrameAnimation.removedOnCompletion = NO;
    label1TranslationKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label1TranslationKeyFrameAnimation.repeatCount = NSIntegerMax;
    [self.label1.layer addAnimation:label1TranslationKeyFrameAnimation forKey:@"self.label1.translationKeyFrameAnimation"];
    
    //标签2
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.label2.center = CGPointMake(self.frame.size.width/2, 0);
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = [UIColor blackColor];
    self.label2.font = [UIFont systemFontOfSize:14];
    self.label2.backgroundColor = [UIColor yellowColor];
    self.label2.text = @"hahahahahhhahahah";
    self.label2.layer.transform = CATransform3DScale(self.label2.layer.transform, 1, 0, 1);
    self.label2.layer.position = CGPointMake(self.label2.layer.position.x, 0);
//    self.label2.alpha = 0;
    [self addSubview:self.label2];
    
    CAKeyframeAnimation *label2ScaleKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    NSValue *label2ScaleValue0 = @(kLYCRBVMinScale);
    NSValue *label2ScaleValue1 = @(1);
    NSArray *label2ScaleValueArray = @[label2ScaleValue0, label2ScaleValue1, label2ScaleValue0, label2ScaleValue0];
    label2ScaleKeyFrameAnimation.values = label2ScaleValueArray;
    label2ScaleKeyFrameAnimation.removedOnCompletion = NO;
    label2ScaleKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label2ScaleKeyFrameAnimation.repeatCount = NSIntegerMax;
    [self.label2.layer addAnimation:label2ScaleKeyFrameAnimation forKey:@"self.label2.scaleKeyFrameAnimation"];
    
    CAKeyframeAnimation *label2TranslationKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    NSValue *label2TranslationValue0 = [NSNumber numberWithFloat:0];
    NSValue *label2TranslationValue1 = [NSNumber numberWithFloat:self.frame.size.height / 2];
    NSValue *label2TranslationValue2 = [NSNumber numberWithFloat:self.frame.size.height];
    NSArray *label2TranslationValueArray = @[label2TranslationValue0, label2TranslationValue1, label2TranslationValue2, label2TranslationValue0];
    label2TranslationKeyFrameAnimation.values = label2TranslationValueArray;
    label2TranslationKeyFrameAnimation.removedOnCompletion = NO;
    label2TranslationKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label2TranslationKeyFrameAnimation.repeatCount = NSIntegerMax;
    [self.label2.layer addAnimation:label2TranslationKeyFrameAnimation forKey:@"self.label2.translationKeyFrameAnimation"];
    
    //标签3
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    self.label2.center = CGPointMake(self.frame.size.width/2, 0);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:14];
    label3.backgroundColor = [UIColor purpleColor];
    label3.text = @"我是谁";
    label3.layer.transform = CATransform3DScale(self.label2.layer.transform, 1, 0, 1);
    label3.layer.position = CGPointMake(self.label2.layer.position.x, 0);
    //    self.label2.alpha = 0;
    [self addSubview:label3];
    
    CAKeyframeAnimation *label3ScaleKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    NSValue *label3ScaleValue0 = @(kLYCRBVMinScale);
    NSValue *label3ScaleValue1 = @(1);
    NSArray *label3ScaleValueArray = @[label3ScaleValue0, label3ScaleValue0, label3ScaleValue1, label3ScaleValue0];
    label3ScaleKeyFrameAnimation.values = label3ScaleValueArray;
    label3ScaleKeyFrameAnimation.removedOnCompletion = NO;
    label3ScaleKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label3ScaleKeyFrameAnimation.repeatCount = NSIntegerMax;
    [label3.layer addAnimation:label3ScaleKeyFrameAnimation forKey:@"self.label2.scaleKeyFrameAnimation"];
    
    CAKeyframeAnimation *label3TranslationKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    NSValue *label3TranslationValue0 = [NSNumber numberWithFloat:self.frame.size.height];
    NSValue *label3TranslationValue1 = [NSNumber numberWithFloat:0];
    NSValue *label3TranslationValue2 = [NSNumber numberWithFloat:self.frame.size.height / 2];
    NSArray *label3TranslationValueArray = @[label3TranslationValue0, label3TranslationValue1, label3TranslationValue2, label3TranslationValue0];
    label3TranslationKeyFrameAnimation.values = label3TranslationValueArray;
    label3TranslationKeyFrameAnimation.removedOnCompletion = NO;
    label3TranslationKeyFrameAnimation.duration = kLYCRBVKeyFrameAnimationDuring;
    label3TranslationKeyFrameAnimation.repeatCount = NSIntegerMax;
    [label3.layer addAnimation:label3TranslationKeyFrameAnimation forKey:@"self.label2.translationKeyFrameAnimation"];

//    if (self.returnBoxStyle == AutoCycleReturnBoxStyle)
//    {
//        if ([self.dataSource count] > 1)
//        {
//            //只有当翻转方式为自动翻转而且数据源不止一条数据的时候开始转动
//            [self startReturn];
//        }
//    }
}

/**
 *  @author liyong
 *
 *  为label添加标题
 *
 *  @param titleIndex 标题序号
 *  @param label      添加标题的label
 */
- (void)setTextAtIndex:(NSInteger)titleIndex ForLabel:(UILabel *)label
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
 *  启动定时器
 */
- (void)startReturn
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_DURING
                                                  target:self
                                                selector:@selector(boxReturn)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)boxReturn
{
    //标记将要显示的标签和将要消失的标签
    if (self.label1.center.y == 0)
    {
        self.showingLabel = self.label1;
        self.hiddingLabel = self.label2;
    }else
    {
        self.showingLabel = self.label2;
        self.hiddingLabel = self.label1;
    }
    
    //设置将要显示的标签标题
    if (self.titleIndex >= [self.dataSource count])
    {
        self.titleIndex = 0;
    }
    [self setTextAtIndex:self.titleIndex++ ForLabel:self.showingLabel];
    
    [UIView animateWithDuration:ANIMATE_DURING
                     animations:^{
                         self.hiddingLabel.transform = CGAffineTransformScale(self.label1.transform, 1, 0.01);
                         self.hiddingLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height);
                         self.hiddingLabel.alpha = 0;
                         
                         self.showingLabel.transform = CGAffineTransformIdentity;
                         self.showingLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                         self.showingLabel.alpha = 1;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             self.hiddingLabel.center = CGPointMake(self.frame.size.width/2, 0);
                         }
                     }];
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
    if (self.returnBoxStyle == NonautomaticReturnBoxStyle)
    {
        //手动翻转的话需要一直保持数据源中只有两条数据
        if([self.dataSource count] > 1)
        {
            [self.dataSource removeObjectAtIndex:0];
            self.titleIndex = 0;
        }
        [self.dataSource addObject:[dataSource firstObject]];
        
        [self boxReturn];
    }else if (self.returnBoxStyle == AutoCycleReturnBoxStyle)
    {
        //清空旧数据
        [self.dataSource removeAllObjects];
        //停止定时器
        if ([self.timer isValid])
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        //添加新数据
        [self.dataSource addObjectsFromArray:dataSource];
        self.titleIndex = 0;
        if ([self.dataSource count] > 1)
        {
            //数据源不止一条数据的时候开始转动
            [self startReturn];
        }
    }
}

@end
