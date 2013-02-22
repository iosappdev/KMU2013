//
//  DZPhotoEntryViewController.m
//  REST
//
//  Created by Simon Kim on 13. 2. 19..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "DZPhotoEntryViewController.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/CGImageProperties.h>


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
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actionSave:(id)sender {
    if ( self.textFieldTitle.text.length > 0 && self.imageView.image ) {
        [self.delegate photoViewControllerDone:self];
    } else {
        NSLog(@"Enter title and photo");
    }
}
- (IBAction)actionFace:(id)sender {
    if (self.imageView.image ) {
        CIImage *image = [[CIImage alloc] initWithCGImage:self.imageView.image.CGImage options:nil];
        
        CIContext *context = [CIContext contextWithOptions:nil]; // 1
        NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                          forKey:CIDetectorAccuracy]; // 2
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:context
                                                  options:opts]; // 3
        NSString *key = CFBridgingRelease( kCGImagePropertyOrientation);
        
        id orientation = [image properties][key];
        if ( orientation == nil ) {
            orientation = @(1);
        }
        opts = @{ CIDetectorImageOrientation : orientation }; // 4
        
        NSArray *features = [detector featuresInImage:image
                                              options:opts];
        for (CIFaceFeature *f in features)
        {
            NSLog(@"%@", NSStringFromCGRect(f.bounds));
            
            if (f.hasLeftEyePosition)
                NSLog(@"Left eye %@\n", NSStringFromCGPoint(f.leftEyePosition));
            if (f.hasRightEyePosition)
                NSLog(@"Right eye %@\n", NSStringFromCGPoint(f.rightEyePosition));
            if (f.hasMouthPosition)
                NSLog(@"Mouth %@\n", NSStringFromCGPoint(f.mouthPosition));
        }
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
