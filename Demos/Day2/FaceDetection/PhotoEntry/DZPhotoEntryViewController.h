//
//  DZPhotoEntryViewController.h
//  REST
//
//  Created by Simon Kim on 13. 2. 19..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZPhotoEntryViewController;
@protocol DZPhotoEntryViewControllerDelegate <NSObject>

- (void) photoViewControllerDone:(DZPhotoEntryViewController *) viewController;

@end

@interface DZPhotoEntryViewController : UIViewController
@property (nonatomic, weak) id<DZPhotoEntryViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *photoTitle;
@property (nonatomic, strong) UIImage *image;

@end
