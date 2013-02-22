//
//  DZRestListViewController.m
//  REST
//
//  Created by Simon Kim on 13. 2. 17..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "DZRestListViewController.h"
#import "DZPhotoEntryViewController.h"
#import "PhotoStore.h"

@interface DZRestListViewController () <DZPhotoEntryViewControllerDelegate>
@property (nonatomic, strong) NSURL *apiURL;
@property (nonatomic, strong, readonly) NSMutableArray *dataList;
@property (nonatomic, strong) PhotoStore *photoStore;
@end

@implementation DZRestListViewController
@synthesize dataList = _dataList;

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

    self.photoStore = [[PhotoStore alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties
- (NSMutableArray *) dataList
{
    if ( _dataList == nil ) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell_listitem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *item = self.dataList[indexPath.row];
    cell.textLabel.text = item[@"title"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark - Storyboard

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ( [segue.identifier isEqualToString:@"push_new"]) {
        DZPhotoEntryViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if ( [segue.identifier isEqualToString:@"push_detail"]) {
        DZPhotoEntryViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        
        if ( [sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *) sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSDictionary *item = self.dataList[indexPath.row];
            vc.photoTitle = item[@"title"];
            UIImage *image = [UIImage imageWithData:item[@"image"]];
            if ( image ) {
                vc.image = image;
            }
        }
    }

}

#pragma mark - DZRestDataViewControllerDelegate
+ (NSString *) newUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return CFBridgingRelease(string);
}


- (void) photoViewControllerDone:(DZPhotoEntryViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
    UIImage *image = viewController.image;
    NSDictionary *dataObject = @{ @"title" : viewController.photoTitle, @"image" : UIImageJPEGRepresentation(image, 0.8)};
    [self.photoStore saveObject:dataObject done:^(id key) {
        [self actionReload:self];
    }];
}

#pragma mark - Internal methods

- (NSArray *) loadDataList
{
    return [self.photoStore loadDataList];

}

#pragma mark - Actions
- (IBAction)actionReload:(id)sender {
    NSArray *list = [self loadDataList];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:list];
    [self.tableView reloadData];
}

@end
