//
//  PJRAddressBook.h
//  PJRAddressBook
//
//  Created by Paritosh Raval on 09/06/14.
//  Copyright (c) 2014 paritosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "PJRPersonContact.h"

typedef enum
{
    ADD_CONTACT = 0,
    UPDATE_CONTACT = 1,
    DELETE_CONTACT = 2
}ContactType;

@interface PJRAddressBook : NSObject

+(BOOL)addressbookOperationForContact:(PJRPersonContact *)contact withContacttype:(ContactType)type;
+ (NSMutableArray *)getPersonContacts;
+ (NSString *)convertToValidString:(NSString *)string;
+ (NSString *)getStringForRecord:(ABRecordRef)record andValue:(int32_t)propertyID;
+ (CFTypeRef)getRefForString:(NSString *)str;





@end
