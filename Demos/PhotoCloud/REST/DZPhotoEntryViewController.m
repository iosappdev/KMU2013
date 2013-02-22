//
//  DZPhotoEntryViewController.m
//  REST
//
//  Created by Simon Kim on 13. 2. 19..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "DZPhotoEntryViewController.h"

@interface DZPhotoEntryViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DZPhotoEntryViewController
@synthesize photoTitle = _photoTitle;
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ( _photoTitle ) {
        self.textFieldTitle.text = _photoTitle;

    }
    if ( _image ) {
        self.imageView.image = _image;
    }
    
    self.textFieldTitle.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Properties
- (NSString *) photoTitle
{
    return self.textFieldTitle.text;
}
- (void) setPhotoTitle:(NSString *)title
{
    _photoTitle = title;
    self.textFieldTitle.text = title;
}
- (UIImage *) image
{
    return self.imageView.image;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

#pragma mark - Actions
- (IBAction)actionPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        // Library
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actionSave:(id)sender {
    if ( self.textFieldTitle.text.length > 0 && self.imageView.image ) {
        [self.delegate photoViewControllerDone:self];
    } else {
        NSLog(@"Enter title and photo");
    }
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
        }
    }];
    
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
