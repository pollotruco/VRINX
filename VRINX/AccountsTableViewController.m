//
//  AccountsTableViewController.m
//  VRINX
//
//  Created by Christian Vazquez on 5/4/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "RESideMenu.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "AccountCell.h"
#import "EntityAccount.h"
#import "AccountDetail.h"
//#import "EmptyAccount.h"
//#import "NoAccountsViewController.h"
//#import "UIViewController+MJPopupViewController.h"
#import "CustomIOS7AlertView.h"

@interface AccountsTableViewController ()<NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *fetchResultsController;


@end

@implementation AccountsTableViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
 //   [self validateUser];
    
    
   //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
  // UIViewController *noAccount = [storyboard instantiateViewControllerWithIdentifier:@"NoAccountID"];
   
    
    //EmptyAccount *emptyAccount = [[EmptyAccount alloc] initWithNibName:@"EmptyAccount" bundle:nil];
    
    
   //[self presentPopupViewController:emptyAccount animationType:MJPopupViewAnimationFade];
    
    
    //CusAlertView *alert = [[CusAlertView alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
    //[self.view addSubview:alert];
    
    //[self.fetchResultsController performFetch:nil];
    
    
  
   // [GlobalPopupAlert show:@"My Message" andFadeOutAfter:5];
   
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Time to start", nil]];
    [alertView addSubview:self.EmptyAccount];
    
    
    [alertView show];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[alertView tag]);
        [alertView close];
    }];
    
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:NO animated:YES];
   // [self validateUser];
    //[GlobalPopupAlert show:@"My Message" andFadeOutAfter:5];
    
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Detail"]){
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
      //  UINavigationController *navigationController = segue.destinationViewController;
       // AccountEditTableViewController  *editAccountVC = (AccountEditTableViewController *) navigationController.topViewController;
        
        //AccountEditTableViewController  *editAccountVC = (AccountEditTableViewController *) segue.destinationViewController;
        //editAccountVC.account = [self.fetchResultsController objectAtIndexPath:indexPath];
        
        AccountDetail *accountDetail = (AccountDetail *) segue.destinationViewController;
        accountDetail.account = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    }
    
}

#pragma mark - Core Data Function
-(NSFetchRequest *)entryListFetchRequest{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    
     fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    
    return fetchRequest;
}
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    //  [self.tableView reloadData];
    
    [self.tableView beginUpdates];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch(type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    
    [self.tableView endUpdates];
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    switch(type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
    }
}


-(NSFetchedResultsController *) fetchResultsController{
    if(_fetchResultsController != nil){
        return _fetchResultsController;
    }
    
   CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
   NSFetchRequest *fetchRequest =[self entryListFetchRequest];
    
  //  _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"name" cacheName:nil];
    
   
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
    
    
    


    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController sections][section];
    
    NSLog(@"# of Records : %lu", (unsigned long)[sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    EntityAccount *entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"Account CELL: %@",entry);
    
    [cell configureCellForEntry:entry];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    EntityAccount *entry =[self.fetchResultsController objectAtIndexPath:indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack  managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
    
    
}


- (IBAction)SlideLeftMenu:(id)sender {
    
    
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

- (void)validateUser
{
    PFUser *currentUser = [PFUser currentUser];
    
    if(!currentUser){
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }else{
        
        [self performSegueWithIdentifier:@"FillAnotherUserInfo" sender:self];
        
        
    }
}
@end
