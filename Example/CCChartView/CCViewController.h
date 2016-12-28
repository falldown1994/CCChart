//
//  CCViewController.h
//  CCChartView
//
//  Created by falldown1994 on 12/27/2016.
//  Copyright (c) 2016 falldown1994. All rights reserved.
//

@import UIKit;
@class CCCustomView;

@interface CCViewController : UIViewController

// 折线图
@property (weak, nonatomic) IBOutlet CCCustomView *lineChartView;

@end
