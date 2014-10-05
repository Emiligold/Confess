//
//  FriendsTab.m
//  Confess
//
//  Created by Noga badhav on 02/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "FriendsTab.h"
#import "SearchFacebook.h"

@interface FriendsTab ()

@end

@implementation FriendsTab

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
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    // Two buttons at the right side of nav bar
    UIBarButtonItem *facebookButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(facebookClicked:)];
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showPicker:)];
    self.navigationItem.rightBarButtonItems = @[contactButton,facebookButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contanctClicked:(id)sender {
}

- (IBAction)clicked:(id)sender {
}

-(void)hideFacebookAction
{
    self.facebookImage.hidden = self.hideFacebook;
    
    NSArray *array = self.confessTab.items;
    NSMutableArray *arrayThatYouCanRemoveObjects = [NSMutableArray arrayWithArray:array];
    
    [arrayThatYouCanRemoveObjects removeObjectAtIndex:2];
    array = [NSArray arrayWithArray: arrayThatYouCanRemoveObjects];
    
    [self.confessTab setItems:array animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Associate"])
    {
        //SearchFacebook *translationQuizAssociateVC = [segue destinationViewController];
        //translationQuizAssociateVC.nodeID = self.nodeID; //--pass nodeID from ViewNodeViewController
        //translationQuizAssociateVC.contentID = self.contentID;
        //translationQuizAssociateVC.index = self.index;
        //translationQuizAssociateVC.content = self.content;
    }
}

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    //self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    //self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}

- (IBAction)facebookClicked:(id)sender {
    //SearchFacebook *newVC = [[SearchFacebook alloc] init];
    //presumably would do some stuff here to set up the new view controller
    //newVC.navigationItem.hidesBackButton = YES;
    //[self.navigationController pushViewController:newVC animated:YES];
    [self performSegueWithIdentifier:@"Associate" sender:sender];
}

@end