//
//  MeTab.h
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DBManager.h"

@interface MeTab : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet NSString *nameText;
@property (weak, nonatomic) IBOutlet NSString *profileID;
-(void)initProperties;
- (IBAction)imageClicked:(id)sender;
@property (nonatomic, assign) BOOL isFullScreen;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (nonatomic, assign) CGRect prevFrame;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIImageView *prop;
@property (nonatomic, assign) CGRect prevFrameButton;
@property (weak, nonatomic) IBOutlet UITableView *confessesTableView;
@property (nonatomic,strong) NSMutableArray *confesses;

@end