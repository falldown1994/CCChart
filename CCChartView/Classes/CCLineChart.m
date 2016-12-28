//
//  CCLineChart.m
//  Pods
//
//  Created by fall1994 on 2016/12/28.
//
//

#import "CCLineChart.h"

@interface CCLineChart () {
    CGFloat _inset; // 偏移量
}

@end

@implementation CCLineChart

#pragma mark - 绘图

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0] set];
    
    // 绘制矩形
    CGFloat x = _inset;
    CGFloat y = _inset;
    CGFloat w = rect.size.width - x * 2.0;
    CGFloat h = rect.size.height - y * 2.0;
    
    CGContextAddRect(ctx, CGRectMake(x, y, w, h));
    
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] set];
    
    NSMutableArray *linesYAxis = [NSMutableArray array];
    
    CGFloat minX = x;
    CGFloat maxX = x + w;
    CGFloat segmentLength = h / 6.0;
    
    for (NSInteger idx = 0; idx < 5; idx++) {
        CGFloat yPoint = (idx + 1) * segmentLength + y;
        CGPoint minXPoint = CGPointMake(minX, yPoint);
        CGPoint maxXPoint = CGPointMake(maxX, yPoint);
        
        CGContextMoveToPoint(ctx, minXPoint.x, minXPoint.y);
        CGContextAddLineToPoint(ctx, maxXPoint.x, maxXPoint.y);
    }
    
    
//    NSMutableArray *linesXAxis = [NSMutableArray array];
//    
//    
//    
//    
//    
//    
//    NSInteger countPoint = self.lineChartData.itemsValue.count;
    
    
    CGContextStrokePath(ctx);
}


#pragma mark - 公共

- (void)setLineChartData:(CCLineChartData *)lineChartData {
    if (lineChartData) {
        _lineChartData = lineChartData;
        
        // 配置绘图参数
        if (_lineChartData.itemsValue.count > 0) {
            // 偏移量
            _inset = 30.0;
            
            [self setNeedsDisplay];
        }
    }
}

@end
