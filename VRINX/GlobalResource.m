//
//  GlobalResource.m
//  VRINX
//
//  Created by Christian Vazquez on 5/28/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "GlobalResource.h"

@implementation GlobalResource

@synthesize selectedContact = _selectedContact;
@synthesize account=_account;
@synthesize backSegueIdentifier = _backSegueIdentifier;

+ (GlobalResource *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalResource *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalResource alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        _selectedContact = [[APContact alloc] init];
        _backSegueIdentifier = [[NSString alloc] init];
        
        //_account=[[EntityAccount alloc] init];
    }
    return self;
}
@end
