//
//  KMUViewController.m
//  demo1
//
//  Created by Simon Kim on 13. 2. 20..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import "KMUViewController.h"

@interface KMUViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation KMUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton1:(UIButton *)sender {
    self.textField.text = sender.titleLabel.text;
}
- (IBAction)actionButton2:(UIButton *)sender {
    self.textField.text = sender.titleLabel.text;

}

@end
