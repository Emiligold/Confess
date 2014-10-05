//
//  MeTab.h
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MeTab : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet NSString *nameText;
@property (weak, nonatomic) IBOutlet NSString *profileID;
-(void)initProperties;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)imageClicked:(id)sender;

@end