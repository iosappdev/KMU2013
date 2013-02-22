//
//  FibViewController.h
//  fibonaci
//
//  Created by Simon Kim on 13. 2. 22..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FibViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfResult;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
