//
//  ViewController.m
//  Dropit
//
//  Created by ceoofufo on 15/7/15.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;
@end

@implementation ViewController

static const CGSize DROP_SIZE = {50,50};

- (UIDynamicAnimator *) animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
    }
    return _animator;
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

- (BOOL) removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height  / 2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width-DROP_SIZE.width/2; x += DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void) animateRemovingDrops:(NSArray*) dropsToRemove
{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x = (arc4random() % (int)(self.gameView.bounds.size.width * 5)) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
                     
        }
    } completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (DropitBehavior *)dropitBehavior
{
    if (!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
        self.animator.delegate = self;
    }
    
    return _dropitBehavior;
}


- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (void) drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.dropitBehavior addItem:dropView];
}

- (UIColor*) randomColor
{
    switch (arc4random() % 5) {
        case 0:
            return [UIColor greenColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor orangeColor];
        case 3:
            return [UIColor redColor];
        case 4:
            return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void) reSetGameRegion
{
    CGRect temp = self.gameView.frame;
    temp.origin = CGPointMake(0,20);
    temp.size.height = self.view.bounds.size.height - 20;
    int w = (int)(self.view.bounds.size.width / DROP_SIZE.width);
    temp.size.width =  w * DROP_SIZE.width;
    temp.origin.x = (self.view.bounds.size.width - temp.size.width) / 2;
    [self.gameView setFrame:temp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reSetGameRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
