//
//  KMUViewController.m
//  Location
//
//  Created by Simon Kim on 13. 2. 21..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import "KMUViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface KMUViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentAccuracy;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIButton *buttonStop;

@end

@implementation KMUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.activity.hidden = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    // Setup Delegate
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionStart:(UIButton *)sender {
    CLLocationAccuracy accuracy = kCLLocationAccuracyNearestTenMeters;
    
    switch (self.segmentAccuracy.selectedSegmentIndex) {
        case 0:
            accuracy = kCLLocationAccuracyNearestTenMeters;
            break;
        case 1:
            accuracy = kCLLocationAccuracyHundredMeters;
            break;
        case 2:
            accuracy = kCLLocationAccuracyKilometer;
            break;
        default:
            break;
    }
    self.locationManager.desiredAccuracy = accuracy;
    [self.locationManager startUpdatingLocation];
    self.activity.hidden = NO;
    [self.activity startAnimating];
    
    self.buttonStart.enabled = NO;
    self.buttonStop.enabled = YES;
    
    self.segmentAccuracy.enabled = NO;
    
}

- (IBAction)actionStop:(id)sender {
    [self.locationManager stopUpdatingLocation];
    
    [self.activity stopAnimating];
    self.activity.hidden = YES;
    
    self.segmentAccuracy.enabled = YES;
    self.buttonStart.enabled = YES;
    self.buttonStop.enabled = NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lon = location.coordinate.longitude;
    // ...
    self.textField.text = [location description];
}

@end
