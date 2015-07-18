//
//  DropitBehavior.h
//  Dropit
//
//  Created by ceoofufo on 15/7/15.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;
@end
