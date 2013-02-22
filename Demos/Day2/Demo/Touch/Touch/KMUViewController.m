//
//  KMUViewController.m
//  Touch
//
//  Created by Simon Kim on 13. 2. 21..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import "KMUViewController.h"

@interface KMUViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation KMUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView.hidden = YES;
    CGRect bounds = self.imageView.bounds;
    bounds.size = CGSizeMake(48, 48);
    self.imageView.bounds = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) animateToPoint:(CGPoint) point
{
    self.imageView.hidden = NO;
    self.imageView.alpha = 0;
    NSLog(@"point:%@", NSStringFromCGPoint(point));
    NSLog(@"%@", NSStringFromCGPoint(self.imageView.center));
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.center = point;
        self.imageView.alpha = 1;
        self.imageView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        NSLog(@"%@", NSStringFromCGPoint(self.imageView.center));
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self animateDisappear];
        }];
    }];
    
}

- (void) animateDisappear
{
    NSLog(@"%@", NSStringFromCGPoint(self.imageView.center));
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0;
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.imageView.hidden = YES;
        NSLog(@"%@", NSStringFromCGPoint(self.imageView.center));
    }];
    
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    NSLog(@"tap");
    CGPoint point = [sender locationInView:self.view];
    [self animateToPoint:point];
}

@end
