//
//  KMUViewController.h
//  Location
//
//  Created by Simon Kim on 13. 2. 21..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface KMUViewController : UIViewController
@property (nonatomic) int count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
