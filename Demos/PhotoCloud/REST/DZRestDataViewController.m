//
//  DZRestDataViewController.m
//  REST
//
//  Created by Simon Kim on 13. 2. 17..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "DZRestDataViewController.h"
#import "Base64Encoder.h"
@interface DZRestDataViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfName1;
@property (weak, nonatomic) IBOutlet UITextField *tfName2;
@property (weak, nonatomic) IBOutlet UITextField *tfName3;
@property (weak, nonatomic) IBOutlet UITextField *tfData1;
@property (weak, nonatomic) IBOutlet UITextField *tfData2;
@property (weak, nonatomic) IBOutlet UITextField *tfData3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSDictionary *dataObjectPending;
@end

@implementation DZRestDataViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ( self.dataObjectPending ) {
        NSString *stringImageData = self.dataObjectPending[@"imageData"];
        if ( stringImageData ) {
            NSData *data = [Base64Encoder base64DataFromString:stringImageData];
            if ( data ) {
                self.imageView.image = [UIImage imageWithData:data];
            }
        }
        self.tfData1.text = self.dataObjectPending[@"title"];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSArray *) fieldNames
{
    NSMutableArray *fieldNames = [NSMutableArray array];
    [fieldNames addObject:self.tfName1.text];
    [fieldNames addObject:self.tfName2.text];
    [fieldNames addObject:self.tfName3.text];
    
    return [fieldNames copy];
}

- (void) setFieldNames:(NSArray *)fieldNames
{
    self.tfName1.text = fieldNames[0];
    self.tfName2.text = fieldNames[1];
    self.tfName3.text = fieldNames[2];
}

- (NSArray *) fieldDataList
{
    NSMutableArray *fieldDataList = [NSMutableArray array];
    [fieldDataList addObject:self.tfData1.text];
    [fieldDataList addObject:self.tfData2.text];
    [fieldDataList addObject:self.tfData3.text];
    
    return [fieldDataList copy];
}

- (void) setFieldDataList:(NSArray *)fieldDataList
{
    self.tfData1.text = fieldDataList[0];
    self.tfData2.text = fieldDataList[1];
    self.tfData3.text = fieldDataList[2];
    
    if ( [fieldDataList[1] length] > 0 ) {
        NSData *data = [Base64Encoder base64DataFromString:fieldDataList[1]];
        if ( data ) {
            self.imageView.image = [UIImage imageWithData:data];
        }
    }
    
}

- (NSDictionary *) dataObject
{
    NSMutableDictionary *dataObject = [NSMutableDictionary dictionary];
    if ( self.tfName1.text.length && self.tfData1.text.length ) {
        dataObject[self.tfName1.text] = self.tfData1.text;
    }
    if ( self.tfName2.text.length && self.tfData2.text.length ) {
        dataObject[self.tfName2.text] = self.tfData2.text;
    }
    if ( self.tfName3.text.length && self.tfData3.text.length ) {
        dataObject[self.tfName3.text] = self.tfData3.text;
    }
    
    return [dataObject copy];
}

- (void) setDataObject:(NSDictionary *)dataObject
{
    self.dataObjectPending = dataObject;
}

- (UIImage *) image
{
    return self.imageView.image;
}
#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Actions
- (IBAction)actionSave:(id)sender {
    if ( self.dataObject.count == 3 ) {
        [self.delegate dataViewControllerDone:self];
    }
}

- (IBAction)actionPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if ( image == nil ) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ( image ) {
            self.imageView.image = image;
            NSData *data = UIImageJPEGRepresentation(image, 0.8);
            self.tfData2.text = [Base64Encoder base64StringFromData:data length:data.length];
        }
    }];
    
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
