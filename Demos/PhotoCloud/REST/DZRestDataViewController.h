//
//  DZRestDataViewController.h
//  REST
//
//  Created by Simon Kim on 13. 2. 17..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZRestDataViewController;
@protocol DZRestDataViewControllerDelegate <NSObject>

- (void) dataViewControllerDone:(DZRestDataViewController *) viewController;

@end
@interface DZRestDataViewController : UITableViewController
@property (nonatomic, weak) id<DZRestDataViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *fieldNames;
@property (nonatomic, copy) NSArray *fieldDataList;
@property (nonatomic, copy) NSDictionary *dataObject;
@property (nonatomic, readonly) UIImage *image;
@end
