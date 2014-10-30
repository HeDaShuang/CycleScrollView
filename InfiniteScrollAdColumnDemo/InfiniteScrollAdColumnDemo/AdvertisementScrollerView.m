//
//  AdvertisementScrollerView.m
//  InfiniteScrollAdColumnDemo
//
//  Created by he on 14-10-29.
//  Copyright (c) 2014年 Anslink. All rights reserved.
//
#import "AdvertisementScrollerView.h"
@implementation AdvertisementScrollerView
@synthesize delegate,timerOne,timerTwo,timerStop,MyScrollView;




-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    self=[super initWithFrame:rect];
	if (self) {
        self.userInteractionEnabled=YES;
        titleArray=titArr;
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		imageArray=[NSArray arrayWithArray:tempArray];
		viewSize=rect;
        
        NSUInteger pageCount=[imageArray count];
        
        MyScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        MyScrollView.pagingEnabled = YES;
        MyScrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        MyScrollView.showsHorizontalScrollIndicator = NO;
        MyScrollView.showsVerticalScrollIndicator = NO;
        MyScrollView.scrollsToTop = NO;
        MyScrollView.delegate = self;
        
        for (int i=0; i<pageCount; i++) {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[UIImageView alloc] init] ;
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用ego异步图片库
            //[imgView setImageWithURL:[NSURL URLWithString:imgURL]placeholderImage:IMAGE_WITH_NAME(@"过度.png")];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [MyScrollView addSubview:imgView];
        }
        [MyScrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:MyScrollView];
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
        //[noteView setBackgroundColor:[UIColor redColor]];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:253/255.0 green:21/255.0 blue:85/255.0 alpha:1]];
        [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
        [noteView addSubview:pageControl];
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
        noteTitle.textColor=[UIColor colorWithRed:255.0/255.0 green:253.0/255.0 blue:241.0/255.0 alpha:1.0];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [noteView addSubview:noteTitle];

        [self addSubview:noteView];

	}
    timerOne = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    timerTwo = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    timerStop =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dragAction) userInfo:nil repeats:YES];
    [timerOne setFireDate:[NSDate distantFuture]];
    [timerStop setFireDate:[NSDate distantFuture]];
	return self;
}


// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
   [MyScrollView scrollRectToVisible:CGRectMake(viewSize.size.width*(page+1),0,viewSize.size.width, viewSize.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
   
}


-(void)timerAction
{

    if (self.contentOffset%320!=0)
    {
        [MyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    else
    {
        
        if (self.contentOffset == 320)
        {
         
            self.contentOffset+=320;
            [timerTwo setFireDate:[NSDate distantPast]];//开启定时器
            [timerOne setFireDate:[NSDate distantFuture]];//关闭定时器
            
        }else if(MyScrollView.contentOffset.x>=640&&MyScrollView.contentOffset.x<320*([imageArray count]-1)){
            
            self.contentOffset+=320;
            
            
        }else if(MyScrollView.contentOffset.x == 320*([imageArray count]-1))
        {
            
            [MyScrollView setContentOffset:CGPointMake(320, 0)];
            [timerTwo setFireDate:[NSDate distantFuture]];
            [timerOne setFireDate:[NSDate distantPast]];
        }

        [MyScrollView setContentOffset:CGPointMake(self.contentOffset, 0) animated:YES];
    }
}

-(void)dragAction
{

    stopTime ++;
    if (stopTime >= 3)
    {
        [timerStop setFireDate:[NSDate distantFuture]];
        [timerTwo setFireDate:[NSDate distantPast]];
        stopTime = 0;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{

 
    CGFloat pageWidth = MyScrollView.frame.size.width;
    self.contentOffset = MyScrollView.contentOffset.x;
    int page = floor((MyScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    pageControl.currentPage=(page-1);
  
    if (page == [imageArray count]-1)
    {
        pageControl.currentPage = 0;
        
    }
  
    
    
//为图片添加上标题
    [noteTitle setText:[titleArray objectAtIndex:pageControl.currentPage]];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    
    //pageIndex 0 1 2 3 4
    if (currentPageIndex==0)
    {
        
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1))
    {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
    
}

static int beginDrag = 0;
static int stopTime = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (currentPageIndex==0)
    {
        
        [scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1))
    {
        
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
    [timerOne setFireDate:[NSDate distantFuture]];
    [timerTwo setFireDate:[NSDate distantFuture]];
    
    beginDrag = 1;
    stopTime = 0;
    if (beginDrag)
    {
        [timerStop setFireDate:[NSDate distantPast]];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    beginDrag = 0;
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if(sender.view.tag==[imageArray count]-1){
        sender.view.tag=1;
    }
    if ([delegate respondsToSelector:@selector(AdvertisementScrollerViewDidClicked:)]) {
        [delegate AdvertisementScrollerViewDidClicked:sender.view.tag];
    }
}

@end
