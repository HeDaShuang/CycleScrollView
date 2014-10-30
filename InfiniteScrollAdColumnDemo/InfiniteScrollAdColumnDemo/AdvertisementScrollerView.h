//
//  AdvertisementScrollerView.h
//  InfiniteScrollAdColumnDemo
//
//  Created by he on 14-10-29.
//  Copyright (c) 2014年 Anslink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvertisementScrollerViewDelegate <NSObject>
@optional
-(void)AdvertisementScrollerViewDidClicked:(NSUInteger)index;
@end

@interface AdvertisementScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	NSArray *imageArray;
    NSArray *titleArray;
    UIPageControl *pageControl;
    id<AdvertisementScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;    
}
@property(nonatomic,strong) NSTimer *timerOne;
@property(nonatomic,strong) NSTimer *timerTwo;
@property(nonatomic,strong) NSTimer *timerStop;
@property(nonatomic,strong) UIScrollView *MyScrollView;
@property(nonatomic, assign) NSInteger contentOffset;

@property(nonatomic,retain)id<AdvertisementScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr;

@end
