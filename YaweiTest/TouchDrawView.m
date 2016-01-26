//
//  TouchDrawView.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "TouchDrawView.h"

@implementation TouchDrawView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.linesCompleted = [[NSMutableArray alloc] init];
        [self setMultipleTouchEnabled:YES];
        
        self.drawColor = [UIColor blackColor];
        [self becomeFirstResponder];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    [self.drawColor set];
    for (Line *line in self.linesCompleted) {
        [[line color] set];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
}

- (void)undo{
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
        [self setNeedsLayout];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.undoManager beginUndoGrouping];
    for (UITouch *touch in touches) {
        CGPoint loc = [touch locationInView:self];
        Line *newLine = [[Line alloc] init];
        newLine.begin = loc;
        newLine.end = loc;
        newLine.color = self.drawColor;
        self.currentLine = newLine;
    }
}

- (void)removeLine:(Line *)line{
    if ([self.linesCompleted containsObject:line]) {
        [self.linesCompleted removeObject:line];
    }
}
- (void)addLine:(Line *)line{
    [[self.undoManager prepareWithInvocationTarget:self] removeLine:line];
    [self.linesCompleted addObject:line];
}


- (void)removeLineByEndPoint:(CGPoint)point{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> * bindings) {
        Line *evaluatedLine = (Line *)evaluatedObject;
        return evaluatedLine.end.x == point.x && evaluatedLine.end.y == point.y;
    }];
    
    NSArray *resultArr = [self.linesCompleted filteredArrayUsingPredicate:predicate];
    if (resultArr && resultArr.count > 0) {
        [self.linesCompleted removeObject:resultArr[0]];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        [self.currentLine setColor:self.drawColor];
        CGPoint loc = [touch locationInView:self];
        [self.currentLine setEnd:loc];
        
        if (self.currentLine) {
            [self addLine:self.currentLine];
        }
        Line *newLine = [[Line alloc]init];
        newLine.begin = loc;
        newLine.end = loc;
        newLine.color = self.drawColor;
        self.currentLine = newLine;
    }
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    [self.undoManager endUndoGrouping];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)didMoveToWindow{
    [self becomeFirstResponder];
}

@end
