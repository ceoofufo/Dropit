//
//  BezierPathView.m
//  Dropit
//
//  Created by ceoofufo on 15/7/18.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (void) setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.path stroke];
}


@end
