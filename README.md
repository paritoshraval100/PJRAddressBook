PJR AddressBook
=====================

It is an AddressBook Component by which you can perform AddressBook related operations like Add Contacts , Updated Contacts , Delete Contacts and Get All Contacts.

Why it is useful to you and what is new in it ?
===============================================================

You can find many AddressBook related codes and components. But in normal use we need list of address book contact in our applications.Most of requirements are to show list in Tableview and perform Add-Update-Remove operations.

So I have create AddressBook component with the help of “AddressBook Framework”.So instead of writing bunch of code you can fulfil your requirement by single line of code.


**What is new ?**

In normal cases other components contains demo with less parameters like name , date, company while we need others too.

So this Components performs operations with

```


firstName,       department,              street,				mobilePhone
lastName,	homeEmail,		city,				mainPhone,
fullName,	workEmail,		state,				iPhonePhone,
company,				country,				homeFaxPhone,
Birthday,				zipcode,				workFaxPhone,
					countrycode,			otherFaxPhone,
									pagerPhone
```


How to use
=====================

**Import two files**

**import "PJRAddressBook.h”** and
**import "PJRPersonContact.h”**


- **Add a Contact by:** ```
[PJRAddressBook addressbookOperationForContact:addContact withContacttype:ADD_CONTACT];```


- **Update particular contact by:** ```
[PJRAddressBook addressbookOperationForContact:addContact withContacttype:UPDATE_CONTACT];```


- **Delete particular contact by:** ```
[PJRAddressBook addressbookOperationForContact:addContact withContacttype:DELETE_CONTACT];```

- **Get all contact array by:** ```
[PJRAddressBook getPersonContacts];```



     
    
    
License
=====================
Paritosh Raval


