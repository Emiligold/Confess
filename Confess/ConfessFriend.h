//
//  ConfessFriend.h
//  Confess
//
//  Created by Noga badhav on 13/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTab.h"
#import "CodeUrls.h"

@interface ConfessFriend : UIViewController <UITextViewDelegate>

extern NSUInteger const MAX_LINES;
-(void)setDetailItem:(NSString*) name : (NSString*) userID : (FriendsTab*) view :
    (NSMutableArray*) dialogs : (CodeUrls*) url url: (UIImage*) image;
- (IBAction)exitClicked:(UIButton *)sender;
-(void)sendConfess:(NSString*) confess;
@property (weak, nonatomic) IBOutlet UIButton *confessButton;
@property (nonatomic, strong) QBChatDialog *dialog;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImage *profileImage;
- (IBAction)imageClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (nonatomic, weak) IBOutlet FriendsTab *friendsView;
@property (nonatomic, strong) CodeUrls *userUrl;
@property (nonatomic, assign) NSUInteger numberOfLines;

@end
