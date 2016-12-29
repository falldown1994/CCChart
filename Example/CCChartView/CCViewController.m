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
    NSMutableArray *itemsValue = [NSMutableArray array];
    for (NSInteger i = 0; i < 150; i++) {
        CGFloat value = (arc4random() % 100) * 0.001 + 1.15 + (arc4random() % 400) * 0.001;
        
        if ((i % 10) == 0) {
            value += (arc4random() % 400) * 0.001;
        }
        [itemsValue addObject:@(value)];
    }
    
    [data setItemsValue:itemsValue];
//    [data setItemsXAxis:@[@"2016/10/20", @"2016/10/25", @"2016/11/02"]];
//    [data setItemsYAxis:@[@"1.54", @"1.77", @"1.98", @"2.79", @"7.99"]];
    
    [self.lineChartView setLineChartData:data];
}

@end
