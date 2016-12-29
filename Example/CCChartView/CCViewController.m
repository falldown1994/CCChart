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
    [data setItemsXAxis:@[@"2016/10/20", @"2016/10/25", @"2016/11/02"]];
    [data setItemsYAxis:@[@"1.54", @"1.77", @"1.98", @"2.79", @"7.99"]];
    
    [self.lineChartView setLineChartData:data];
}

@end
