//
//  ViewController.m
//  InfiniteScrollAdColumnDemo
//
//  Created by he on 14-10-29.
//  Copyright (c) 2014年 Anslink. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AdvertisementScrollerView* ads=[[AdvertisementScrollerView alloc]initWithFrameRect:CGRectMake(0, 20, 320, 140) ImageArray:@[@"11.jpg",@"22.jpg",@"33.jpg",@"44.jpg",@"55.jpg"] TitleArray:@[@"标题一",@"标题二",@"标题三",@"标题四",@"标题五"]];
    ads.delegate=self;
    [self.view addSubview:ads];
    
}
-(void)AdvertisementScrollerViewDidClicked:(NSUInteger)index
{
    
}


@end
