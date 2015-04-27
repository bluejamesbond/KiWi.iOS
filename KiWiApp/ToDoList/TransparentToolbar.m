//
//  TransparentToolbar.m
//  KiWi
//
//  Created by Kapil Gowru on 4/25/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "TransparentToolbar.h"

@implementation TransparentToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.translucent = YES;
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
}

@end
