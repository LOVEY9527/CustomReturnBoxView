//
//  LYCustomReturnBoxView.h
//  CustomLayoutTest
//
//  Created by li_yong on 16/3/2.
//  Copyright © 2016年 li_yong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AutoCycleReturnBoxStyle,    //自动循环翻转
    NonautomaticReturnBoxStyle, //非自动翻转
} ReturnBoxStyle;

@interface LYCustomReturnBoxView : UIView

//内容对齐方式
@property (nonatomic) NSTextAlignment textAlignment;
//内容字体大小
@property (nonatomic, strong) UIFont *textFont;
//内容字体颜色
@property (nonatomic, strong) UIColor *textColor;

/**
 *  @author li_yong
 *
 *  初始化方法
 *
 *  @param frame
 *  @param dataSource     数据源(字符串/富文本)
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
         DataSource:(NSArray *)dataSource;

/**
 *  @author li_yong
 *
 *  添加新数据
 *
 *  @param dataSource 新数据(字符串/富文本)
 */
- (void)refreshWithDataSource:(NSArray *)dataSource;

@end
