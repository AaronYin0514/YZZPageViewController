//
//  ZZPageViewController.h
//  ZZPageViewController
//
//  Created by Aaron on 16/8/22.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZZPageViewControllerDataSource;
@protocol ZZPageViewControllerDelegate;

@interface ZZScrollView : UIScrollView

@end

@interface ZZPageViewController : UIViewController
/**
 *  控制器之间的间隔宽度，默认值为15.0，通过代理设置该值
 */
@property (nonatomic, assign, readonly) CGFloat padding;
/**
 *  控制器的父视图
 */
@property (nonatomic, strong, readonly) ZZScrollView *contentScrollView;
/**
 *  数据源
 */
@property (nonatomic, weak) id<ZZPageViewControllerDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic, weak) id<ZZPageViewControllerDelegate> delegate;

@end

@protocol ZZPageViewControllerDataSource <NSObject>

@required
/**
 *  返回子控制器个数
 *
 *  @param pageViewController 当前PageViewController
 *
 *  @return 子控制器个数
 */
-(NSInteger)numbersOfSubViewControllers:(ZZPageViewController *)pageViewController;
/**
 *  返回每个位置的控制器
 *
 *  @param pageViewController 当前PageViewController
 *  @param index              位置索引
 *
 *  @return 返回每个位置的控制器
 */
-(UIViewController *)pageViewController:(ZZPageViewController *)pageViewController memberAtIndex:(NSInteger)index;

@end

@protocol ZZPageViewControllerDelegate <NSObject>

@optional
/**
 *  控制器之间的间隔宽度，注意，控制器之间间隔宽度与两边漏出来的控制器宽度相同
 *
 *  @param pageViewController 当前PageViewController
 *
 *  @return 控制器之间的间隔宽度
 */
-(CGFloat)paddingForItemInPageViewController:(ZZPageViewController *)pageViewController;
/**
 *  用于设置控制器视图与父视图上下间隔，只有上下值起作用，左右间隔宽度用padding控制
 *
 *  @param pageViewController 当前PageViewController
 *
 *  @return 设置控制器视图与父视图上下间隔
 */
-(UIEdgeInsets)edgeInsetsForMemberInPageViewController:(ZZPageViewController *)pageViewController;

@end
