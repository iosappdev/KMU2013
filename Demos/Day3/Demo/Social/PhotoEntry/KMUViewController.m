//
//  KMUViewController.m
//  PhotoEntry
//
//  Created by Simon Kim on 13. 2. 20..
//
//

#import "KMUViewController.h"

@interface KMUViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@end

@implementation KMUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textField.text = @"Load some photo";
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionButton:(id)sender {
    
    // Camera가 있는 아이폰인가?
    BOOL cameraAvail = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    if ( cameraAvail) {
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:NULL];
    
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if ( image == nil ) {
            // No edited image. Try original.
            image = info[UIImagePickerControllerOriginalImage];
        }
        self.imageView.image = image;
    }];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)actionShare:(id)sender {
    if ( self.textField.text.length > 0 && self.imageView.image) {
        NSArray *items = @[ self.textField.text, self.imageView.image ];
        
        UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        [self presentViewController:viewController animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Enter title and photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
@end
