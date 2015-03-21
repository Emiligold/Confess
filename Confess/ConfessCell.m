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

#define padding 20

@interface ConfessCell ()

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) FriendsTab *friendsTab;
@property (nonatomic, strong) MeTab *meTab;

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

        //CGPointMake(self.contentView.frame.size.width / 2,
         //                              self.contentView.frame.size.height / 2);
        
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
        self.date.center = CGPointMake(self.view.frame.size.width / 2, 175);
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
    
    if (!self.isMine)
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

@end
