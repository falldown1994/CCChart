//
//  CCLineChart.m
//  Pods
//
//  Created by fall1994 on 2016/12/28.
//
//

#import "CCLineChart.h"

@interface CCLineChart () {
//    CGFloat _inset; // 偏移量
}

@end

@implementation CCLineChart

#pragma mark - 绘图

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor blackColor] set];
    
    // 绘制矩形
    CGFloat x = 8.0;
    CGFloat y = x;
    CGFloat w = rect.size.width - x * 2.0;
    CGFloat h = rect.size.height - y * 2.0;
    
    CGContextAddRect(ctx, CGRectMake(x, y, w, h));
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] set];
    
    // Y轴的虚线
    NSMutableArray *linesYAxis = [NSMutableArray array];
    // X轴的虚线
    NSMutableArray *linesXAxis = [NSMutableArray array];
    
    CGFloat minX = x;
    CGFloat maxX = x + w;
    CGFloat minY = y;
    CGFloat maxY = y + h;
    NSInteger segmentCount = 4;
    CGFloat segmentLengthY = h / segmentCount;
    CGFloat segmentLengthX = w / segmentCount;
    
    for (NSInteger idx = 0; idx < (segmentCount - 1); idx++) {
        // Y轴上的网格线
        CGFloat yPoint = (idx + 1) * segmentLengthY + y;
        CGPoint minXPoint = CGPointMake(minX, yPoint);
        CGPoint maxXPoint = CGPointMake(maxX, yPoint);
        // X轴上的网格线
        CGFloat xPoint = (idx + 1) * segmentLengthX + x;
        CGPoint minYPoint = CGPointMake(xPoint, minY);
        CGPoint maxYpoint = CGPointMake(xPoint, maxY);
        
        CGContextMoveToPoint(ctx, minXPoint.x, minXPoint.y);
        CGContextAddLineToPoint(ctx, maxXPoint.x, maxXPoint.y);
        
        CGContextMoveToPoint(ctx, minYPoint.x, minYPoint.y);
        CGContextAddLineToPoint(ctx, maxYpoint.x, maxYpoint.y);
    }
    
    CGContextStrokePath(ctx);
    
//    CGContextRestoreGState(ctx);
//    CGContextSaveGState(ctx);
//    
//    CGContextSetLineWidth(ctx, 1.0);
//    [[UIColor redColor] set];
    
    NSArray *itemsValue = _lineChartData.itemsValue;
    __block CGFloat minValueY = [itemsValue[0] floatValue];
    __block CGFloat maxValueY = [itemsValue[0] floatValue];
    
    [itemsValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            CGFloat valueY = [itemsValue[idx] floatValue];
            
            if (valueY < minValueY) {
                minValueY = valueY;
            }
            
            if (valueY > maxValueY) {
                maxValueY = valueY;
            }
        }
    }];
    // 最大值和最小值上下浮动0.1
    minValueY /= 1.2;
    maxValueY *= 1.2;

    // 计算Y坐标轴刻度值
    NSMutableArray *valueYAxis = [NSMutableArray array];
    CGFloat offset = (maxValueY - minValueY) / 4.0;
    for (NSInteger idx = 0; idx < 3; idx++) {
        CGFloat value = minValueY + (idx + 1) * offset;
        [valueYAxis addObject:@(value)];
    }
    [valueYAxis insertObject:@(minValueY) atIndex:0];
    [valueYAxis addObject:@(maxValueY)];
    
    CGFloat drawX = x + 3.0;
    
    [valueYAxis enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *drawString = [NSString stringWithFormat:@"%.2lf", [obj floatValue]];
        
        CGRect rect = [drawString boundingRectWithSize:CGSizeMake(w, segmentLengthY) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
        
        CGFloat drawH = rect.size.height;
        CGFloat drawW = rect.size.width;
        CGFloat drawY = y + (4.0 - idx) * segmentLengthY;
        CGFloat offset = 0.0;
        if (0 == idx) {
            offset -= (drawH + 2.0);
        } else if (valueYAxis.count - 1 == idx) {
            offset += 2.0;
        } else {
            offset -= drawH * 0.5;
        }
        
        drawY += offset;
        
        [drawString drawInRect:CGRectMake(drawX, drawY, drawW, drawH) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor redColor]}];
    }];
    

    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1.0);
    [[UIColor darkGrayColor] set];
    // 确定每一个值对应的坐标
    NSMutableArray *points = [NSMutableArray array];
    
    CGFloat valueLengthX = w / (itemsValue.count - 1);
    [itemsValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemValue = [(NSString *)obj floatValue];
        CGFloat ratioY = (itemValue - minValueY) / (maxValueY - minValueY);
        // 计算Y坐标点
        CGFloat valueY = h * (1 - ratioY) + x;
        CGFloat valueX = idx * valueLengthX + x;
        if (0 == idx) {
            valueX += 1.0;
        } else if (itemsValue.count - 1 == idx) {
            valueX -= 1.0;
        }
        
        NSLog(@"y: %lf, x: %lf", y, x);
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(valueX, valueY)]];
    }];
    
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *pointValue = (NSValue *)obj;
        CGPoint point = [pointValue CGPointValue];
        
        if (0 == idx) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        } else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }];
    
    CGContextStrokePath(ctx);
}


#pragma mark - 公共

- (void)setLineChartData:(CCLineChartData *)lineChartData {
    if (lineChartData) {
        _lineChartData = lineChartData;
        
        // 配置绘图参数
        if (_lineChartData.itemsValue.count > 0) {
            [self setNeedsDisplay];
        }
    }
}

@end
