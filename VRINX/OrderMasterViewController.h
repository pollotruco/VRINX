//
//  OrderMasterViewController.h
//  VRINX
//
//  Created by Christian Vazquez on 5/15/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempOrderProduct.h"

@class EntityProduct,EntityContactOrder,EntityOrder;

@interface OrderMasterViewController : UITableViewController

//@property(nonatomic,strong) EntityAccount *account;

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *productCell;

@property (weak, nonatomic) IBOutlet UITextField *orderNumberField;
@property (weak, nonatomic) IBOutlet UITextField *taxField;
@property (weak, nonatomic) IBOutlet UITextField *shippingField;

@property (weak, nonatomic) IBOutlet UITextField *additionalCostField;

@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemsTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *shippingTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *taxTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *additionalTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *granTotalLabel;


//@property(nonatomic,strong) NSMutableArray *orderProducts;
@property(nonatomic) bool withoutSave;

- (IBAction)cancelOrder:(id)sender;

- (IBAction)TaxValueChange:(id)sender;

- (IBAction)shippingValueChange:(id)sender;
- (IBAction)additionalValueChange:(id)sender;

@end
