//
//  FibViewController.m
//  fibonaci
//
//  Created by Simon Kim on 13. 2. 22..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import "FibViewController.h"

// Import Header for Worker class
#import "Worker.h"

@interface FibViewController ()
// Define a property of Worker class
@property (nonatomic, strong) Worker *worker;
@end

@implementation FibViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.worker = [[Worker alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void) processBackgroundInput:(NSString *) input button:(UIButton *) button
{
    [self.activity startAnimating];
    button.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        NSString *result = [self.worker process:input];
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            self.tfResult.text = result;
            [self.activity stopAnimating];
            button.enabled = YES;
        });
    });
}

- (void) processResponsiveInput:(NSString *) input button:(UIButton *) button
{
    [self.activity startAnimating];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //
        self.tfResult.text = [self.worker process:input];
        [self.activity stopAnimating];
    }];
    
}
- (void) processNRInput:(NSString *) input button:(UIButton *) button
{
    
    self.tfResult.text = [self.worker process:input];
}

// Button [Process] touched
- (IBAction)actionCalc:(UIButton *)sender {
    
    if ( self.tfNumber.text.length > 0 ) {
        self.tfResult.text = @"";
        // If Input Available, Process
        // [self processNRInput:self.tfNumber.text button:sender];
        // [self processResponsiveInput:self.tfNumber.text button:sender];
        // [self processBackgroundInput:self.tfNumber.text button:sender];
    } else {
        // No Input, Alert
        [self alertMessage:@"Enter Input Text" title:@"Information"];
    }
}

// Easy-to-use Alert method
// -----------------
// [Title]
// -----------------
// [Message]
// [OK]
// -----------------
- (void) alertMessage:(NSString *) message title:(NSString *) title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
@end
