//
//  CCLineChart.m
//  Pods
//
//  Created by fall1994 on 2016/12/28.
//
//

#import "CCLineChart.h"
#import "CCGridLineData.h"

@interface CCLineChart () {
    // 水平方向网格线
    NSMutableArray *_gridLinesHorizontal;
    // 垂直方向网格线
    NSMutableArray *_gridLinesVertical;
    // 行数/列数
    NSUInteger _rowCount;
    // 垂直方向文本值
    NSMutableArray *_itemsValueForAxisY;
    // 垂直方向文本值绘制区域
    NSMutableArray *_itemsDrawRectForAxisY;
    //
    NSMutableArray *_itemsDrawPointForLine;
    // Y轴数值文本的最大值/最小值
    CGFloat _minValueForAxisY;
    CGFloat _maxValueForAxisY;
}

@end

@implementation CCLineChart

#pragma mark ------------------------------

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setNeedsConfiguration];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // 绘制边框
    cc_drawBorderRect(ctx, self.bounds, [UIColor blackColor], 1.0);
    // 绘制网格线
    cc_drawGridLine(ctx, _gridLinesHorizontal, _gridLinesVertical, [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0], 1.0);
    // 绘制Y轴文本值
    cc_drawTextForAxisY(ctx, _itemsValueForAxisY, _itemsDrawRectForAxisY, @{NSFontAttributeName:[UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor redColor]});
    // 绘制曲线
    cc_drawLine(ctx, _itemsDrawPointForLine, [UIColor darkGrayColor], 1.0);
}


#pragma mark ------------------------------

- (void)setLineChartData:(CCLineChartData *)lineChartData {
    if (lineChartData) {
        _lineChartData = lineChartData;
        
        // 配置绘图参数
        if (_lineChartData.itemsValue.count > 0) {
            [self setNeedsDisplay];
        }
    }
}


#pragma mark ------------------------------

void cc_drawLine(CGContextRef context, NSArray<NSValue *> *
    itemsDrawPointForLine, UIColor *color,
                    CGFloat lineWidth)
{
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, lineWidth);
    [color set];
    
    [itemsDrawPointForLine enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [obj CGPointValue];
        
        if (0 == idx) {
            CGContextMoveToPoint(context, point.x, point.y);
        } else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }];
    
    CGContextStrokePath(context);
}

void cc_drawTextForAxisY(CGContextRef context, NSArray<
    NSString *> *itemsForDrawText,
                         NSArray<NSValue *> *
                            itemsForDrawRect, NSDictionary *
                                attributes)
{
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    [itemsForDrawText enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect drawRect = [itemsForDrawRect[idx] CGRectValue];
        [obj drawInRect:drawRect withAttributes:attributes];
    }];
}

void cc_drawGridLine(CGContextRef context, NSArray<
    CCGridLineData *> *gridLinesHorizontal,
                     NSArray<CCGridLineData *> *
                        gridLinesVertical, UIColor *color,
                            CGFloat lineWidth)
{
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, lineWidth);
    [color set];
    
    // horizontal
    [gridLinesHorizontal enumerateObjectsUsingBlock:^(CCGridLineData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextMoveToPoint(context, obj.startPoint.x, obj.startPoint.y);
        CGContextAddLineToPoint(context, obj.endPoint.x, obj.endPoint.y);
    }];
    
    // vertical
    [gridLinesVertical enumerateObjectsUsingBlock:^(CCGridLineData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextMoveToPoint(context, obj.startPoint.x, obj.startPoint.y);
        CGContextAddLineToPoint(context, obj.endPoint.x, obj.endPoint.y);
    }];
    
    CGContextStrokePath(context);
}



void cc_drawBorderRect(CGContextRef context,
                       CGRect drawRect,
                       UIColor *color, CGFloat lineWidth)
{
    CGContextRestoreGState(context);
    CGContextSaveGState(context);

    CGContextSetLineWidth(context, lineWidth);
    [color set];
    
    CGContextAddRect(context, drawRect);
    CGContextStrokePath(context);
}


#pragma mark ------------------------------

- (void)setNeedsConfiguration {
    
    if (!_gridLinesHorizontal) {
        _gridLinesHorizontal = [NSMutableArray array];
    } else {
        [_gridLinesHorizontal removeAllObjects];
    }
    
    if (!_gridLinesVertical) {
        _gridLinesVertical = [NSMutableArray array];
    } else {
        [_gridLinesVertical removeAllObjects];
    }
    
    _rowCount = 5;
    
    // grid line
    CGRect bounds = self.bounds;
    
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat minX = bounds.origin.x;
    CGFloat maxX = minX + w;
    
    CGFloat minY = bounds.origin.y;
    CGFloat maxY = minY + h;
    
    NSInteger segmentCount = _rowCount - 1;
    CGFloat segmentLengthY = h / segmentCount;
    CGFloat segmentLengthX = w / segmentCount;
    
    for (NSInteger idx = 0; idx < (segmentCount - 1); idx++) {
        // horizontal
        CGFloat yHorGridLine = (idx + 1) * segmentLengthY;
        
        CCGridLineData *horGridLineData = [[CCGridLineData alloc] init];
        horGridLineData.startPoint = CGPointMake(minX, yHorGridLine);
        horGridLineData.endPoint = CGPointMake(maxX, yHorGridLine);
        
        // vertical
        CGFloat xVerGridLine = (idx + 1) * segmentLengthX;
        
        CCGridLineData *verGridLineData = [[CCGridLineData alloc] init];
        verGridLineData.startPoint = CGPointMake(xVerGridLine, minY);
        verGridLineData.endPoint = CGPointMake(xVerGridLine, maxY);
        
        [_gridLinesHorizontal addObject:horGridLineData];
        [_gridLinesVertical addObject:verGridLineData];
    }
    
    // -----------
    NSArray<NSString *> *itemsValue = _lineChartData.itemsValue;
    // min value axis y
    __block CGFloat minValueForAxisY = [itemsValue[0] floatValue];
    // max value axis y
    __block CGFloat maxValueForAxisY = [itemsValue[0] floatValue];
    
    [itemsValue enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            CGFloat valueForAxisY = [obj floatValue];
            
            if (valueForAxisY < minValueForAxisY) {
                minValueForAxisY = valueForAxisY;
            }
            
            if (valueForAxisY > maxValueForAxisY) {
                maxValueForAxisY = valueForAxisY;
            }
        }
    }];
    
    minValueForAxisY /= 1.2;
    maxValueForAxisY *= 1.2;
    
    _minValueForAxisY = minValueForAxisY;
    _maxValueForAxisY = maxValueForAxisY;
    
    // value items
    if (!_itemsValueForAxisY) {
        _itemsValueForAxisY = [NSMutableArray array];
    } else {
        [_itemsValueForAxisY removeAllObjects];
    }
    
    CGFloat valueForSegment = (maxValueForAxisY - minValueForAxisY) / segmentCount;
    for (NSInteger idx = 0; idx < (segmentCount - 1); idx++) {
        CGFloat itemValue = minValueForAxisY + (idx + 1) * valueForSegment;
        [_itemsValueForAxisY addObject:[NSString stringWithFormat:@"%.2lf", itemValue]];
    }
    [_itemsValueForAxisY insertObject:[NSString stringWithFormat:@"%.2lf", minValueForAxisY] atIndex:0];
    [_itemsValueForAxisY addObject:[NSString stringWithFormat:@"%.2lf", maxValueForAxisY]];
    
    // draw rect
    if (!_itemsDrawRectForAxisY) {
        _itemsDrawRectForAxisY = [NSMutableArray array];
    } else {
        [_itemsDrawRectForAxisY removeAllObjects];
    }
    
    [_itemsValueForAxisY enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *drawString = (NSString *)obj;
        
        CGRect rect = [drawString boundingRectWithSize:CGSizeMake(w, segmentLengthY) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
        
        CGFloat drawX = 3.0;
        CGFloat drawH = rect.size.height;
        CGFloat drawW = rect.size.width;
        CGFloat drawY = (segmentCount - idx) * segmentLengthY;
        CGFloat offset = 0.0;
        
        if (0 == idx) {
            offset -= (drawH + 2.0);
        } else if (_itemsValueForAxisY.count - 1 == idx) {
            offset += 2.0;
        } else {
            offset -= drawH * 0.5;
        }
        
        drawY += offset;
        
        [_itemsDrawRectForAxisY addObject:[NSValue valueWithCGRect:CGRectMake(drawX, drawY, drawW, drawH)]];
    }];
    
    // draw line
    if (!_itemsDrawPointForLine) {
        _itemsDrawPointForLine = [NSMutableArray array];
    } else {
        [_itemsDrawPointForLine removeAllObjects];
    }
    
    // 确定每一个值对应的坐标
    CGFloat valueLengthX = w / (itemsValue.count - 1);
    [itemsValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemValue = [(NSString *)obj floatValue];
        CGFloat ratioY = (itemValue - minValueForAxisY) / (maxValueForAxisY - minValueForAxisY);
        // 计算Y坐标点
        CGFloat valueY = h * (1 - ratioY);
        CGFloat valueX = idx * valueLengthX;
        if (0 == idx) {
            valueX += 1.0;
        } else if (itemsValue.count - 1 == idx) {
            valueX -= 1.0;
        }
        [_itemsDrawPointForLine addObject:[NSValue valueWithCGPoint:CGPointMake(valueX, valueY)]];
    }];
}

@end
