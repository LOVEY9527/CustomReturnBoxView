//
//  ViewController.m
//  LYCustomReturnBoxTest
//
//  Created by 李勇 on 17/3/16.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import "LYCustomReturnBoxView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LYCustomReturnBoxView *customReturnBoxView = [[LYCustomReturnBoxView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 30)
                                                                                        style:AutoCycleReturnBoxStyle
                                                                                   DataSource:@[@"1购买了小秘书得到了价值￥5000股票",
                                                                                                @"2购买了小秘书得到了价值￥5000股票",
                                                                                                @"3购买了小秘书得到了价值￥5000股票"]];
//    customReturnBoxView.textAlignment = NSTextAlignmentLeft;
//    customReturnBoxView.textFont = [UIFont systemFontOfSize:10];
    customReturnBoxView.textColor = [UIColor grayColor];
//    customReturnBoxView.backgroundColor = [UIColor redColor];
    [self.view addSubview:customReturnBoxView];
    
    return;
    
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = self.view.layer.position;
    btn.bounds = CGRectMake(0, 0, 100, 50);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnClick:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.testView.layer.presentationLayer addObserver:self
                                            forKeyPath:@"position"
                                               options:NSKeyValueObservingOptionNew
                                               context:nil];
    
//    CAKeyframeAnimation *testKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(25, 225)];
//    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(225, 225)];
//    NSArray *valueArray = @[value1, value2];
//    testKeyFrameAnimation.values = valueArray;
//    testKeyFrameAnimation.removedOnCompletion = NO;
//    testKeyFrameAnimation.fillMode = kCAFillModeBoth;
//    testKeyFrameAnimation.duration = 5;
//    testKeyFrameAnimation.delegate = self;
//    [self.testView.layer addAnimation:testKeyFrameAnimation forKey:@""];
    
//    if ([self.testView.layer.presentationLayer isKindOfClass:[CALayer class]])
//    {
//        NSLog(@"self.testView.layer.presentationLayer");
//    }
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallBack:)];
//    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)btnClick:(UIButton *)sender
{
    if ([self.testView.layer.presentationLayer isKindOfClass:[CALayer class]])
    {
        CALayer *layer = (CALayer *)self.testView.layer.presentationLayer;
        layer.position = CGPointMake(150, 225);
    }
}

- (void)displayLinkCallBack:(CADisplayLink *)displayLink
{
    if ([self.testView.layer.presentationLayer isKindOfClass:[CALayer class]])
    {
        CALayer *layer = (CALayer *)self.testView.layer.presentationLayer;
        NSLog(@"animationDidStop:%@", NSStringFromCGPoint(layer.position));
    }
}

#pragma mark - KVC func

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"observeValueForKeyPath");
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animationDidStart");
    
    if ([self.testView.layer.presentationLayer isKindOfClass:[CALayer class]])
    {
        [self.testView.layer addObserver:self
                              forKeyPath:@"presentationLayer.position"
                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                 context:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    if ([self.testView.layer.presentationLayer isKindOfClass:[CALayer class]])
//    {
//        CALayer *layer = (CALayer *)self.testView.layer.presentationLayer;
//        NSLog(@"animationDidStop:%@", NSStringFromCGPoint(layer.position));
//        
//        [self.testView.layer.presentationLayer removeObserver:self];
//    }
    
//    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
