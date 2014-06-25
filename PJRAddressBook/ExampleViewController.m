//
//  ExampleViewController.m
//  PJRAddressBook
//
//  Created by Paritosh Raval on 09/06/14.
//  Copyright (c) 2014 paritosh. All rights reserved.
//

#import "ExampleViewController.h"
#import "PJRAddressBook.h"
#import "PJRPersonContact.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

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
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addressBookOperations:(id)sender
{
    _personarray = [PJRAddressBook getPersonContacts];
    if([sender tag] == 0){
        // Add Contact to Device's Addressbook
        PJRPersonContact *addContact = [[PJRPersonContact alloc] init];
        addContact.firstName = @"Hello";
        addContact.lastName = @"World";
        addContact.company = @"Test Company";
        
        addContact.department = @"department abc";
        addContact.birthday = [NSDate date];
        addContact.mobilePhone = @"2333445454";
        addContact.homeEmail = @"a@b.com";
        if([PJRAddressBook addressbookOperationForContact:addContact withContacttype:ADD_CONTACT]){
            [self showAlertWithMessage:@"Added Successfully..."];
        }

    }
    else if ([sender tag] == 1){
        // Get contacts from Device's Addressbook
        _personarray = [PJRAddressBook getPersonContacts];
        
        if([_personarray count]){
            [self showAlertWithMessage:@"Please Check Log"];

        }
        else{
            [self showAlertWithMessage:@"Please Add atleast one record to AddressBook"];

        }
        for (PJRPersonContact *contact in _personarray)
        {
            NSLog(@"first name:%@",contact.firstName);
            NSLog(@"last name:%@",contact.lastName);
            NSLog(@"full name:%@",contact.fullName);
            NSLog(@"company name:%@",contact.company);
            NSLog(@"dept name:%@",contact.department);
            NSLog(@"birthday name:%@",contact.birthday);
            NSLog(@"mob:%@",contact.mobilePhone);
            NSLog(@"iphone:%@",contact.iPhonePhone);
        }

    }
        
    else if ([ sender tag] ==2){
        // Update Contact
        
        if(_personarray.count){
            PJRPersonContact *updateContact = [_personarray objectAtIndex:0];
            updateContact.firstName = @"new name";
            if([PJRAddressBook addressbookOperationForContact:updateContact withContacttype:UPDATE_CONTACT]){
                [self showAlertWithMessage:@"Updated Successfully..."];
            }
        }
        else{
            [self showAlertWithMessage:@"Please Add atleast one record to AddressBook"];

        }
    }
    else{
        // Delete Contact
        
        if(_personarray.count){
            PJRPersonContact *deleteContact = [_personarray objectAtIndex:0];
            if([PJRAddressBook addressbookOperationForContact:deleteContact withContacttype:DELETE_CONTACT]){
                [self showAlertWithMessage:@"Deleted Successfully..."];
            }
        }
        else{
            [self showAlertWithMessage:@"Please Add atleast one record to AddressBook"];

        }

    }
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PJRAddressBook" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
