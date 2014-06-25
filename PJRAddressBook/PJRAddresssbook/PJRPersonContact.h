//
//  PJRPersonContact.h
//  PJRAddressBook
//
//  Created by Paritosh Raval on 09/06/14.
//  Copyright (c) 2014 paritosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJRPersonContact : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSDate *birthday;

@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *countrycode;


@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *mainPhone;
@property (nonatomic, strong) NSString *iPhonePhone;
@property (nonatomic, strong) NSString *homeFaxPhone;
@property (nonatomic, strong) NSString *workFaxPhone;
@property (nonatomic, strong) NSString *otherFaxPhone;
@property (nonatomic, strong) NSString *pagerPhone;

@property (nonatomic, strong) NSArray *allPhonesArray;
@property (nonatomic, strong) NSMutableDictionary *instantMSGDict;
@property (nonatomic, strong) NSMutableDictionary *relativeDict;

@property (nonatomic, strong) NSNumber *recordId;


@property (nonatomic, strong) UIImage *thumbImage;






@end
