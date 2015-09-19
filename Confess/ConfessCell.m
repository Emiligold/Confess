//
//  ConfessCell.m
//  Confess
//
//  Created by Noga badhav on 20/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "ConfessCell.h"
#import "ConfessEntity.h"
#import "DateHandler.h"
#import "FriendsTab.h"
#import "ColorsHandler.h"
#import "DBManager.h"
#import "DBServices.h"
#import "MeTab.h"
#import "LikeDislike.h"

#define padding 20

typedef enum UserInteraction : NSUInteger
{
    Liked = 0,
    Hated = 1,
    None = 2
} UserInteraction;

@interface ConfessCell ()

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) FriendsTab *friendsTab;
@property (nonatomic, strong) MeTab *meTab;
@property (nonatomic, strong) UIButton *smileyButton;
@property (nonatomic, strong) UIButton *saddyButton;
@property (nonatomic, strong) UIImage *saddySelected;
@property (nonatomic, strong) UIImage *saddy;
@property (nonatomic, strong) UIImage *smiley;
@property (nonatomic, strong) UIImage *smileySelected;
@property (nonatomic, strong) UIImage *chat;
@property (nonatomic, strong) LikeDislike *likeDislike;

@end

@implementation ConfessCell

- (void)awakeFromNib
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)mine friendsTab:(FriendsTab*)friendsTab meTab:(MeTab*)meTab
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.isMine = mine;
        self.friendsTab = friendsTab;
        self.meTab = meTab;
        
        self.view = [[UIView alloc] init];
        CGRect viewFrame = CGRectMake(0, 0, 235, 200);
        [self.view setFrame:viewFrame];
        self.view.layer.cornerRadius = 25;
        self.view.layer.masksToBounds = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.view];
        self.view.center = CGPointMake(self.contentView.frame.size.width / 2, 124);
        
        // Images init
        self.smiley = [UIImage imageNamed:@"smiley.png"];
        self.saddy = [UIImage imageNamed:@"saddy.png"];
        self.saddySelected = [UIImage imageNamed:@"saddySelected.png"];
        self.smileySelected = [UIImage imageNamed:@"smileySelected.png"];
        self.chat = [UIImage imageNamed:@"chatIcon.png"];
        self.smiley = [self imageWithImage:self.smiley scaledToSize:CGSizeMake(84, 64)];
        self.saddy = [self imageWithImage:self.saddy scaledToSize:CGSizeMake(84, 64)];
        self.smileyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saddySelected = [self imageWithImage:self.saddySelected scaledToSize:CGSizeMake(84, 64)];
        UIImageView *smileyImageView = [[UIImageView alloc] initWithImage:self.smiley];
        CGRect smileyButtonFrame = CGRectMake(self.view.frame.size.width / 2 + 27, 143, 84, 64);
        smileyImageView.center = CGPointMake(self.view.frame.size.width / 2 + 65, 175);
        self.smileyButton.center = CGPointMake(self.view.frame.size.width / 2 + 65, 175);
        [self.smileyButton setFrame:smileyButtonFrame];
        [self.view addSubview:self.smileyButton];
        self.saddyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect sadButtonFrame = CGRectMake(self.view.frame.size.width / 2 - 12, 144, 84, 64);
        UIImageView *saddyImageView = [[UIImageView alloc] initWithImage:self.saddy];
        saddyImageView.center = CGPointMake(self.view.frame.size.width / 2 + 25, 177);
        UIImageView *saddySelectedImageView = [[UIImageView alloc] initWithImage:self.saddySelected];
        saddySelectedImageView.center = CGPointMake(self.view.frame.size.width / 2 + 25, 177);
        [self.saddyButton setFrame:sadButtonFrame];
        [self.view addSubview:self.saddyButton];
        
        // Image Initialize
        self.profileImage = [[UIImageView alloc] init];
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.layer.cornerRadius = 20;
        self.profileImage.center = CGPointMake(self.view.frame.size.width / 2, 30);
        self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.profileImage];
        
        // Label initialize
        CGRect frame = CGRectMake(0, 0, 190, 30);
        self.name = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.name setFrame:frame];
        self.name.center = CGPointMake(self.view.frame.size.width / 2, 75);
        [self.view addSubview:self.name];
        
        // Text initialize
        self.content = [[UITextView alloc] init];
        [self.view addSubview:self.content];
        
        // Exit initialize
        CGRect exitFrame = CGRectMake(0, 0, 50, 50);
        self.exit = [UIButton buttonWithType:UIButtonTypeSystem];
        self.exit.frame = exitFrame;
        [self.exit setTitle: @"X" forState: UIControlStateNormal];
        [self.exit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:self.exit];
        
        // Date initialize
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 30)];
        self.date.center = CGPointMake(self.view.frame.size.width / 2 - 60, 175);
        self.date.font=[self.date.font fontWithSize:12];
        self.date.textColor = [UIColor grayColor];
        self.date.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.date];
    }
    
    return self;
}

+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message isMine:(BOOL)isMine;
{
    //NSString *text = message.content;
	//CGSize  textSize = {260.0, 10000.0};
	//CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
    //               constrainedToSize:textSize
    //                   lineBreakMode:NSLineBreakByWordWrapping];
    
	
	//size.height += 45.0;
	//NSInteger final = isMine ? size.height : 60 + size.height;
    return 250;
}

- (void)configureCellWithConfess:(ConfessEntity *)message;
{
    self.confess = message;
    NSInteger ySize = self.isMine ? padding : padding + 70;
    self.date.text = [DateHandler getDateMessageString:message.lastMessageDate];
    
    //[self.date sizeToFit];
    self.date.backgroundColor = [UIColor clearColor];
    self.content.text = message.content;
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.scrollEnabled = NO;
    self.content.backgroundColor = [UIColor clearColor];
    self.content.editable = NO;
    //CGSize textSize = { 260.0, 10000.0 };
	//CGSize size = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
    //                                    constrainedToSize:textSize
    //                                        lineBreakMode:NSLineBreakByWordWrapping];
	//size.width += 10;
    [self.content sizeToFit];
    [self.content setFrame:CGRectMake(padding / 2, ySize, 216, 75)];
    [self.exit addTarget:self action:@selector(exitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isMine)
    {
        self.likeDislike = [self getLikeDislike];
        [self.smileyButton setImage:(self.likeDislike != nil && self.likeDislike.isLike) ?
         self.smileySelected : self.smiley forState:UIControlStateNormal];
        [self.saddyButton setImage:(self.likeDislike != nil && !self.likeDislike.isLike) ?
         self.saddySelected : self.saddy forState:UIControlStateNormal];
        [self.smileyButton addTarget:self action:@selector(smileyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.saddyButton addTarget:self action:@selector(saddyClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.name setTitle: message.toName forState: UIControlStateNormal];
        [self.name setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.name addTarget:self
                      action:@selector(friendClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        self.profileImage.bounds = CGRectMake(0,0,50,50);
        self.profileImage.frame = CGRectMake(93,15,50,50);
        NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:message.url.url]];
        UIImage *image = [UIImage imageWithData:data];
        self.profileImage.image = image;
        self.name.backgroundColor = [UIColor clearColor];

    }
}

- (IBAction)friendClicked:(id)sender
{
    [self.friendsTab friendClicked:self];
}

- (IBAction)exitClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.name.titleLabel.text message:self.content.text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"remove", @"block",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (!self.isMine)
        {
            [self.friendsTab.dialogs removeObject:self.confess];
            [self.friendsTab.allDialogs removeObject:self.confess];
            
            if ([self.friendsTab.urlOrIdToDialog objectForKey:self.confess.url.url] != nil)
            {
                for (NSObject *curr in self.friendsTab.dialogs)
                {
                    if ([curr isKindOfClass:[ConfessEntity class]])
                    {
                        ConfessEntity *confessEntity = (ConfessEntity*)curr;
                        
                        if ([confessEntity.url.url isEqualToString:self.confess.url.url])
                        {
                            [self.friendsTab.urlOrIdToDialog setObject:confessEntity forKey:confessEntity.url.url];
                            
                            break;
                        }
                    }
                    else
                    {
                        //TODO: QBChatDialog
                    }
                }
            }
            
            [self.friendsTab.chatTable reloadData];
        }
        else
        {
            [self.meTab.confesses removeObject: self.confess];
            [self.meTab.confessesTableView reloadData];
        }
        
        self.confess.isDeleted = YES;
        [DBServices mergeEntity:self.confess];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)smileyClicked:(id)sender
{
    //TODO: NotifyUser
    [self.smileyButton setImage:(self.likeDislike != nil && self.likeDislike.isLike) ? self.smiley : self.smileySelected forState:UIControlStateNormal];
    
    if (self.likeDislike != nil && !self.likeDislike.isLike)
    {
        [self.saddyButton setImage:self.saddy forState:UIControlStateNormal];
    }
    
    if (self.likeDislike != nil)
    {
        if (self.likeDislike.isLike)
        {
            [DBServices deleteEntityById:[[LikeDislike alloc] init] entityClass:self.likeDislike.objectID];
            self.likeDislike = nil;
        }
        else
        {
            self.likeDislike.isLike = YES;
            [DBServices mergeEntity:self.likeDislike];
        }
    }
    else
    {
        self.likeDislike = [[LikeDislike alloc] init];
        self.likeDislike.confessID = self.confess.objectID;
        self.likeDislike.isLike = YES;
        self.likeDislike.userID = [DBServices currUserId];
        [DBServices mergeEntity:self.likeDislike];
        self.likeDislike.objectID = (int)[[DBManager shared] lastInsertedRowID];
    }
}

- (IBAction)saddyClicked:(id)sender
{
    //TODO: Notify user
    [self.saddyButton setImage:(self.likeDislike != nil && !self.likeDislike.isLike) ? self.saddy : self.saddySelected forState:UIControlStateNormal];
    
    if (self.likeDislike != nil && self.likeDislike.isLike)
    {
        [self.smileyButton setImage:self.smiley forState:UIControlStateNormal];
    }
    
    if (self.likeDislike != nil)
    {
        if (!self.likeDislike.isLike)
        {
            [DBServices deleteEntityById:[[LikeDislike alloc] init] entityClass:self.likeDislike.objectID];
            self.likeDislike = nil;
        }
        else
        {
            self.likeDislike.isLike = NO;
            [DBServices mergeEntity:self.likeDislike];
        }
    }
    else
    {
        self.likeDislike = [[LikeDislike alloc] init];
        self.likeDislike.confessID = self.confess.objectID;
        self.likeDislike.isLike = NO;
        self.likeDislike.userID = [DBServices currUserId];
        [DBServices mergeEntity:self.likeDislike];
        self.likeDislike.objectID = (int)[[DBManager shared] lastInsertedRowID];
    }
}

-(LikeDislike*)getLikeDislike
{
    NSUInteger userId = [[LocalStorageService shared] currentUser].ID;
    return [DBServices getEntityByUniqe:[[LikeDislike alloc] init] entityClass:
                                [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"user_id = '%d'", userId], [NSString stringWithFormat:@"confess_id = '%d'", self.confess.objectID], nil]];
}

@end
