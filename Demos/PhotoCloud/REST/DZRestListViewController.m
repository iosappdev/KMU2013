//
//  DZRestListViewController.m
//  REST
//
//  Created by Simon Kim on 13. 2. 17..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "DZRestListViewController.h"
#import "DZPhotoEntryViewController.h"
#import <QuartzCore/QuartzCore.h>

#define API_URL @"http://backend.dzpub.com:2403/photos?{\"$sort\":{\"dateCreated\":-1}}"
#define API_UPLOAD_URL @"http://backend.dzpub.com/lab/upload/upload_file.php"


@interface DZRestListViewController () <DZPhotoEntryViewControllerDelegate>
@property (nonatomic, strong) NSURL *apiURL;
@property (nonatomic, strong, readonly) NSMutableArray *dataList;
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

    // REST GET API
    NSString *urlString = API_URL;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.apiURL = [NSURL URLWithString:urlString];
    
    // Customizing Navigation Bar
    UIImage *imageNavigationBar = [UIImage imageNamed:@"nav_top_main"];
    imageNavigationBar = [imageNavigationBar resizableImageWithCapInsets:UIEdgeInsetsMake(8, 60, 0, 14)];
    [self.navigationController.navigationBar setBackgroundImage:imageNavigationBar forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:imageNavigationBar forBarMetrics:UIBarMetricsLandscapePhone];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self actionReload:self];
    }];
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
    static NSString *CellIdentifier = @"cell_feeditem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Photo Item Cell Configuration
    
    // Configure the cell...
    NSDictionary *item = self.dataList[indexPath.row];
    //cell.textLabel.text = item[@"title"];
    
    UIView *border = [cell.contentView viewWithTag:13];
    border.backgroundColor = [UIColor whiteColor];
    border.layer.cornerRadius = 8;
    
    //border.layer.borderWidth = 1;
    //border.layer.borderColor = [UIColor colorWithRed:248.0/255 green:148.0 / 255 blue:6.0 / 255 alpha:1].CGColor;
    
    border.layer.shadowColor = [UIColor colorWithRed:248.0/255 green:148.0 / 255 blue:6.0 / 255 alpha:1].CGColor;
    border.layer.shadowRadius = 2;
    border.layer.shadowOffset = CGSizeMake( 0, 0);
    border.layer.shadowOpacity = 1;

    cell.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *) [cell.contentView viewWithTag:12];

    UILabel *labelTitle = (UILabel *)[cell.contentView viewWithTag:10];
    if ( labelTitle ) {
        labelTitle.text = item[@"title"];
    }
    
    // Delayed loading image from the Link
    UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:11];
    if ( imageView ) {
        imageView.image = nil;
        NSString *link = item[@"link"];
        if ( link ) {
            activity.hidden = NO;
            [activity startAnimating];
            [self loadImageAtURL:[NSURL URLWithString:link] done:^(UIImage *image) {
                if ( image ) {
                    imageView.image = image;
                }
                activity.hidden = YES;
                [activity stopAnimating];
            }];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark - Storyboard

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // View Controller Transition Configuration
    
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
            NSString *link = item[@"link"];
            if ( link ) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *d, NSError *e) {
                    if ( d ) {
                        vc.image = [UIImage imageWithData:d];
                    }
                }];
            }
        }
    }

}

- (void) loadImageAtURL:(NSURL *) URL done:(void (^)(UIImage *image)) done
{
    // API: Loading Remote Image
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *r, NSData *d, NSError *e) {
        UIImage *image = nil;
        if ( d ) {
            image = [UIImage imageWithData:d];
        }
        done(image);
    }];
}

#pragma mark - DZRestDataViewControllerDelegate
+ (NSString *) newUUID
{
    // API: Unique ID for the image file name
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return CFBridgingRelease(string);
}


- (void) photoViewControllerDone:(DZPhotoEntryViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
    UIImage *image = viewController.image;
    if ( image ) {
        NSURL *URL = [NSURL URLWithString:API_UPLOAD_URL];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        
        [self uploadFileData:data URL:URL filename:[[[self class] newUUID] stringByAppendingPathExtension:@"jpg"] done:^(NSURL *URL) {
            //
            if ( URL ) {
                NSLog(@"URL:%@", URL);
                NSDictionary *dataObject = @{ @"title" : viewController.photoTitle, @"link" : [URL absoluteString]};
                [self saveObject:dataObject done:^(NSDictionary *result) {
                    //
                    [self actionReload:self];
                }];
            }
        }];
    }
}
#pragma mark - Internal methods
- (NSURLRequest *)uploadRequestFileData:(NSData *) data URL:(NSURL *) URL filename:(NSString *) filename contentType:(NSString *) contentType
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------7d44e178b0434";
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"request raw data:");
    NSLog(@"%@", [NSString stringWithUTF8String:body.bytes]);
    
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    return request;
}

- (void) uploadFileData:(NSData *) data URL:(NSURL *) URL filename:(NSString *) filename done:(void (^)(NSURL *URL)) done
{
    NSURLRequest *request = [self uploadRequestFileData:data URL:URL filename:filename contentType:@"image/jpeg"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
        //
        NSURL *url = nil;
        if ( error ) NSLog(@"error:%@", error);
        if ( response ) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"response:%@", [httpResponse allHeaderFields]);
        }
        if ( data ) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
            if ( result ) {
                NSLog(@"Result:%@", result);
                url = [NSURL URLWithString: result[@"link"]];
            }
        }
        done(url);
    }];
}

- (NSArray *) loadDataList
{
    NSArray *result = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.apiURL];
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ( data ) {
        result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    return result;
}

- (void) sampleLoadDataListDone:(void (^)(NSArray *result)) done
{
    NSURL *URL = [NSURL URLWithString:@"http://localhost:2403/photos"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            // completion block
            if ( data ) {
                NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                done(result);
            }
    }];
}

- (void) saveObject:(NSDictionary *) dataObject done:(void (^)(NSDictionary *result)) done
{
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:&error];
    if ( data ) {
        NSURL *URL = self.apiURL;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:data];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", data.length] forHTTPHeaderField:@"Content-Length"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSDictionary *result = nil;
            if ( error ) NSLog(@"error:%@", error);
            if ( response ) NSLog(@"response:%@", response);
            if ( data ) {
                result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if ( result ) {
                    NSLog(@"Result:%@", [result allKeys]);
                }
            }
            done(result);
        }];
    }
}

#pragma mark - Actions
- (IBAction)actionReload:(id)sender {
    NSArray *list = [self loadDataList];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:list];
    [self.tableView reloadData];
}

@end
