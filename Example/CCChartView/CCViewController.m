//
//  CCViewController.m
//  CCChartView
//
//  Created by falldown1994 on 12/27/2016.
//  Copyright (c) 2016 falldown1994. All rights reserved.
//

#import "CCViewController.h"
#import "CCLineChart.h"
#import "CCCustomView.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CCLineChartData *data = [[CCLineChartData alloc] init];
    
    [data setItemsValue:@[
                          @"4.23", @"3.22", @"1.74",
                          @"2.86", @"1.99", @"2.43",
                          @"6.34"
                          ]];
    
    [self.lineChartView setLineChartData:data];
}

@end
