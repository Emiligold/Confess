//
//  ConfessView.h
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTab.h"
#import "ConfessEntity.h"

@interface ConfessView : UIViewController

-(void)setDetailItem:(NSString*) name : (NSString*) userID : (FriendsTab*) view :
    (NSMutableArray*) dialogs : (NSString*) url url: (UIImage*) image;
@property (weak, nonatomic) IBOutlet UINavigationItem *check;
@property (weak, nonatomic) IBOutlet UIButton *confessButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *writeButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) QBChatDialog *dialog;
@property (nonatomic, weak) IBOutlet UIImage *friendImage;
@property (nonatomic, strong) NSString *userID;
-(void)sendConfess:(NSString*) confess;

@end
