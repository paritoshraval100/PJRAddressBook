//
//  PJRAddressBook.m
//  PJRAddressBook
//
//  Created by Paritosh Raval on 09/06/14.
//  Copyright (c) 2014 paritosh. All rights reserved.
//

#import "PJRAddressBook.h"
@implementation PJRAddressBook



+(BOOL)addressbookOperationForContact:(PJRPersonContact *)contact withContacttype:(ContactType)type
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                
            } else {
                [PJRAddressBook addressbookOperationForContact:contact withContacttype:type];
            }
        });
    }    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        //Add Person to Addressbook
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABRecordRef contactRecord = NULL;
        
        
        if(type == ADD_CONTACT ){
            contactRecord = ABPersonCreate();
        }
        else if(type == UPDATE_CONTACT){
            contactRecord = ABAddressBookGetPersonWithRecordID(addressBook, contact.recordId.integerValue);
        }
        else{
            contactRecord = ABAddressBookGetPersonWithRecordID(addressBook, contact.recordId.integerValue);
            CFErrorRef  anError = NULL;
            ABAddressBookRemoveRecord(addressBook, contactRecord, &anError);
            BOOL success = ABAddressBookSave(addressBook, nil);
            return success;


        }
        
        if(!contact)
            return NO;
        
        // Add Basic information
        
        
        ABRecordSetValue(contactRecord, kABPersonFirstNameProperty,[PJRAddressBook getRefForString:contact.firstName] , nil);
        ABRecordSetValue(contactRecord, kABPersonLastNameProperty,[PJRAddressBook getRefForString:contact.lastName], nil);
        ABRecordSetValue(contactRecord, kABPersonOrganizationProperty,[PJRAddressBook getRefForString:contact.company], nil);
        ABRecordSetValue(contactRecord, kABPersonDepartmentProperty,[PJRAddressBook getRefForString:contact.department], nil);
        ABRecordSetValue(contactRecord, kABPersonBirthdayProperty,(__bridge CFTypeRef)(contact.birthday), nil);
        
        //Add Phones
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        ABMultiValueAddValueAndLabel(multiPhone, [PJRAddressBook getRefForString:contact.mobilePhone], kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multiPhone, [PJRAddressBook getRefForString:contact.iPhonePhone], kABPersonPhoneIPhoneLabel, NULL);
        ABMultiValueAddValueAndLabel(multiPhone, [PJRAddressBook getRefForString:contact.mainPhone], kABPersonPhoneMainLabel, NULL);
        ABMultiValueAddValueAndLabel(multiPhone, [PJRAddressBook getRefForString:contact.homeFaxPhone], kABPersonPhoneHomeFAXLabel, NULL);
        ABMultiValueAddValueAndLabel(multiPhone,[PJRAddressBook getRefForString:contact.otherFaxPhone], kABPersonPhoneOtherFAXLabel, NULL);
        ABMultiValueAddValueAndLabel(multiPhone,[PJRAddressBook getRefForString:contact.pagerPhone], kABPersonPhonePagerLabel, NULL);

        ABRecordSetValue(contactRecord, kABPersonPhoneProperty, multiPhone,nil);
        CFRelease(multiPhone);
        
        
        //Add Email
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        ABMultiValueAddValueAndLabel(multiEmail, [PJRAddressBook getRefForString:contact.homeEmail], kABHomeLabel, NULL);
        ABMultiValueAddValueAndLabel(multiEmail, [PJRAddressBook getRefForString:contact.workEmail], kABWorkLabel, NULL);
        ABRecordSetValue(contactRecord, kABPersonEmailProperty, multiEmail, nil);
        
        //Add Address
        
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);

        
        if (contact.street) [addressDictionary setObject:contact.street forKey:(NSString *)kABPersonAddressStreetKey];
        if (contact.city) [addressDictionary setObject:contact.city forKey:(NSString *)kABPersonAddressCityKey];
        if (contact.state) [addressDictionary setObject:contact.state forKey:(NSString *)kABPersonAddressStateKey];
        if (contact.zipcode) [addressDictionary setObject:contact.zipcode forKey:(NSString *)kABPersonAddressZIPKey];
        if (contact.country) [addressDictionary setObject:contact.country forKey:(NSString *)kABPersonAddressCountryKey];
        if (contact.countrycode) [addressDictionary setObject:contact.countrycode forKey:(NSString *)kABPersonAddressCountryCodeKey];
        
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
        ABRecordSetValue(contactRecord, kABPersonAddressProperty, multiAddress,&error);
        CFRelease(multiAddress);

        
        
        
        // Add Thumb Image
        NSData *dataRef = UIImagePNGRepresentation(contact.thumbImage);
        ABPersonSetImageData(contactRecord, (__bridge CFDataRef)dataRef, nil);
        CFRelease(multiEmail);
        
        ABAddressBookAddRecord(addressBook, contactRecord, nil);
        BOOL success = ABAddressBookSave(addressBook, nil);
        
        CFRelease(contactRecord);
        
        return success;
    
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        
        
    }

    return                 [PJRAddressBook addressbookOperationForContact:contact withContacttype:type];
;
    
}

+ (NSMutableArray *)getPersonContacts
{
    NSMutableArray *personArray = nil;
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
            } else {
                [PJRAddressBook getPersonContacts];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        
        if (addressBook != nil) {
            NSLog(@"Succesful.");
            personArray = [[NSMutableArray alloc] init];

            
            CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex  peopleCount = ABAddressBookGetPersonCount(addressBook);
            
            
            NSUInteger i = 0; for (i = 0; i < peopleCount; i++)
            {
                PJRPersonContact *contact = [[PJRPersonContact alloc] init];
                ABRecordRef contactRecord = CFArrayGetValueAtIndex(allContacts, i);
                
                contact.recordId = [NSNumber numberWithInteger:ABRecordGetRecordID(contactRecord)];
                //Basic information
                contact.firstName = [PJRAddressBook getStringForRecord:contactRecord andValue:kABPersonFirstNameProperty];
                contact.fullName = [PJRAddressBook convertToValidString:(__bridge_transfer NSString *)ABRecordCopyCompositeName(contactRecord)];
                
                contact.company = [PJRAddressBook getStringForRecord:contactRecord andValue:kABPersonOrganizationProperty];
                contact.department = [PJRAddressBook getStringForRecord:contactRecord andValue:kABPersonDepartmentProperty];
                contact.birthday = (__bridge NSDate *)(ABRecordCopyValue(contactRecord, kABPersonBirthdayProperty));


                //Emails
                 ABMultiValueRef emails = ABRecordCopyValue(contactRecord, kABPersonEmailProperty);
                
                            NSUInteger j = 0;
                            for (j = 0; j < ABMultiValueGetCount(emails); j++) {
                                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                                if (j == 0) {
                                    contact.homeEmail = [PJRAddressBook convertToValidString:email];
                                }
                                else if (j==1) contact.workEmail = [PJRAddressBook convertToValidString:email];
                            }
                
                
                
                // Address
                ABMultiValueRef address = ABRecordCopyValue(contactRecord, kABPersonAddressProperty);
                
                for (CFIndex j = 0; j < ABMultiValueGetCount(address); j++) {
                    
                    CFDictionaryRef addressRef = ABMultiValueCopyValueAtIndex(address, j);
                    
                    NSDictionary *addressDict = (__bridge NSDictionary*)addressRef;
                    
                    
                    contact.street = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"Street"]];

                    contact.city = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"City"]];

                    contact.state = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"State"]];
                    
                    contact.zipcode = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"ZIP"]];
                    
                    contact.country = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"Country"]];
                    
                    contact.countrycode = [PJRAddressBook convertToValidString:[addressDict objectForKey:@"CountryCode"]];
            }
             
            //Phones
                ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(contactRecord, kABPersonPhoneProperty);
                CFArrayRef phoneref = ABMultiValueCopyArrayOfAllValues(phones);
                contact.allPhonesArray = (__bridge NSArray*)phoneref;


                
                for (int i=0; i < ABMultiValueGetCount(phones); i++) {
                    CFStringRef label = ABMultiValueCopyLabelAtIndex(phones, i);

                    NSString *valueStr =[PJRAddressBook convertToValidString:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) ];
                    if(label)
                    {
                        if (CFEqual(label, kABPersonPhoneMobileLabel)) {
                            contact.mobilePhone = valueStr;
                            /* it's the user's work phone */
                        } else if (CFEqual(label, kABPersonPhoneIPhoneLabel)) {
                            contact.iPhonePhone = valueStr;
                        }else if (CFEqual(label, kABPersonPhoneMainLabel)) {
                            contact.mainPhone = valueStr;
                        }else if (CFEqual(label, kABPersonPhoneHomeFAXLabel)) {
                            contact.homeFaxPhone = valueStr;

                        }else if (CFEqual(label, kABPersonPhoneWorkFAXLabel)) {                            contact.workFaxPhone = valueStr;
                            
                        }else if (CFEqual(label, kABPersonPhoneOtherFAXLabel)) {
                            contact.otherFaxPhone = valueStr;

                        }else if (CFEqual(label, kABPersonPhonePagerLabel)) {
                            contact.pagerPhone = valueStr;
                        }
                        
                    }

                }
                
                ABMultiValueRef instantMessage = ABRecordCopyValue(contactRecord,
                                                                   kABPersonInstantMessageProperty);
                
                NSMutableDictionary *instantMessageDict = [NSMutableDictionary dictionaryWithCapacity:0];

                
                for (CFIndex j = 0; j < ABMultiValueGetCount(instantMessage); j++) { //
                    
                    CFDictionaryRef imRef = ABMultiValueCopyValueAtIndex(instantMessage, j); //
                    NSDictionary *imDict = (__bridge NSDictionary*)imRef;
                    [instantMessageDict setObject:[imDict objectForKey:@"username"] forKey:[imDict
                                                                                            objectForKey:@"service"]];


                }
                
                contact.instantMSGDict  = instantMessageDict;
                
                
                
                //Other Relatives
                
                ABMultiValueRef relatedNames = ABRecordCopyValue(contactRecord, kABPersonRelatedNamesProperty);
                NSMutableDictionary *relativeDict = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for(CFIndex j = 0; j < ABMultiValueGetCount(relatedNames); j++)
                {
                    NSString *relatedNameLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(relatedNames, j) ;
                    
                    NSString *relatedNameString = (__bridge NSString*)ABMultiValueCopyValueAtIndex(relatedNames, j);
                    // Add the object to the dictionary
                    [relativeDict setValue:relatedNameString forKey:relatedNameLabel];
                }
                
                contact.relativeDict = relativeDict;
                
                //Person Thumb Image
                NSData  *imgData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(contactRecord, kABPersonImageFormatThumbnail);
                
                if (imgData)
                {
                    contact.thumbImage = [UIImage imageWithData:imgData];
                    imgData = nil;
                }

            [personArray addObject:contact];

        }
            
            return personArray;
            
        } else {
        }

    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        

    }
    return  [PJRAddressBook getPersonContacts];
;
    
}

+ (NSString *)convertToValidString:(NSString *)string
{
    if([string length] != 0 && string != nil ){
        return string;
    }
    return @"";
}

+ (NSString *)getStringForRecord:(ABRecordRef)record andValue:(int32_t)propertyID
{
    NSString *string = (__bridge_transfer NSString *)ABRecordCopyValue(record, propertyID);
    return [PJRAddressBook convertToValidString:string];
}

+ (CFTypeRef)getRefForString:(NSString *)str
{
    return (__bridge CFTypeRef)str;
}



@end
