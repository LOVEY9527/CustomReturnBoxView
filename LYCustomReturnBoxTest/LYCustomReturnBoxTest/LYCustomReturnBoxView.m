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

@interface LYCustomReturnBoxView()

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
    if (self.titleIndex < [self.dataSource count])
    {
        [self setTextAtIndex:self.titleIndex++ ForLabel:self.label1];
    }
    [self addSubview:self.label1];
    
    //标签2
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label2.center = CGPointMake(self.frame.size.width/2, 0);
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = [UIColor blackColor];
    self.label2.font = [UIFont systemFontOfSize:14];
    self.label2.transform = CGAffineTransformScale(self.label2.transform, 1, 0);
    self.label2.alpha = 0;
    [self addSubview:self.label2];
    
    if (self.returnBoxStyle == AutoCycleReturnBoxStyle)
    {
        if ([self.dataSource count] > 1)
        {
            //只有当翻转方式为自动翻转而且数据源不止一条数据的时候开始转动
            [self startReturn];
        }
    }
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
