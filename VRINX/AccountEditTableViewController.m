//
//  AccountEditTableViewController.m
//  VRINX
//
//  Created by Christian Vazquez on 5/5/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "AccountEditTableViewController.h"
#import "CoreDataStack.h"
#import "EntityAccount.h"
#import "CroperViewController.h"

@interface AccountEditTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImage *pickedImage;

@end

@implementation AccountEditTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(self.account != nil){
        // edit mode
        
        self.accountNameField.text = self.account.name;
        self.descriptionField.text= self.account.shortDesc;
        self.salesTaxField.text = [NSString stringWithFormat:@"%@", self.account.tax];
        self.earningPercentField.text = [NSString stringWithFormat:@"%@", self.account.earningPercent];
        self.pickedImage = [UIImage imageWithData:self.account.logo];
        self.logoView.image = self.pickedImage;
        
        
        
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"cropImage"]){
        
        CroperViewController *cropper = [[CroperViewController alloc]  init];
        cropper = (CroperViewController *) segue.destinationViewController;
        cropper.sourceImage = [self pickedImage];
    
    }
    
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    self.pickedImage =  info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"cropImage" sender:self];
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) createAccount{
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    EntityAccount *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    account.name = self.accountNameField.text;
    account.shortDesc = self.descriptionField.text;
    account.tax = [NSDecimalNumber decimalNumberWithString:self.salesTaxField.text];
    account.earningPercent =[NSDecimalNumber decimalNumberWithString:self.earningPercentField.text];
    account.logo = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    
    [coreDataStack saveContext];
    
    
}
-(void) updateAccount{
    
    
    self.account.name = self.accountNameField.text;
    self.account.shortDesc = self.descriptionField.text;
    self.account.tax = [NSDecimalNumber decimalNumberWithString:self.salesTaxField.text];
    self.account.earningPercent =[NSDecimalNumber decimalNumberWithString:self.earningPercentField.text];
    self.account.logo = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

#pragma mark - Table view data source
-(void)dismissSelf{
     [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)save:(id)sender {
    
    if(self.account != nil){
        [self updateAccount];
    }else{
        [self createAccount];
    }
    
    [self dismissSelf];
    
    
}

- (IBAction)changeLogo:(id)sender {
    
    //if device have camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else{
        [self promptForPhotoRoll];
    }
    
}
-(void) promptForSource{
    UIActionSheet *actionSheed = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Roll", nil];
    
    [actionSheed showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if(buttonIndex != actionSheet.firstOtherButtonIndex){
            [self promptForCamera];
        }else{
            [self promptForPhotoRoll];
        }
    }
}

-(void)promptForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void) setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    if(pickedImage == nil){
        self.logoView.image  = [UIImage imageNamed:@"icn_noimage"];
    }else{
        self.logoView.image = pickedImage;
    }
}

@end
