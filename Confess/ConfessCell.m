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
#import <QuartzCore/QuartzCore.h>

#define padding 20

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
@property (nonatomic, strong) UIView *modalView;

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
        self.view.center = CGPointMake(self.contentView.frame.size.width / 2, 124);
        
        // Images init
        self.smiley = [UIImage imageNamed:@"smiley2.png"];
        self.saddy = [UIImage imageNamed:@"saddy2.png"];
        self.saddySelected = [UIImage imageNamed:@"saddySelected.png"];
        self.smileySelected = [UIImage imageNamed:@"smileySelected.png"];
        self.chat = [UIImage imageNamed:@"chatIcon.png"];
        self.smiley = [self imageWithImage:self.smiley scaledToSize:CGSizeMake(40, 40)];
        self.saddy = [self imageWithImage:self.saddy scaledToSize:CGSizeMake(40, 40)];
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
        self.content.delegate = self;
        //[self.content addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
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
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"IMG_9548 2.PNG"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowOffset = CGSizeMake(-15, 10);
        self.view.layer.shadowRadius = 3;
        self.view.layer.shadowOpacity = 0.5;
        //self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        [self.contentView addSubview:self.view];

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

- (void)configureCellWithConfess:(ConfessEntity *)message isMine:(BOOL)isMine;
{
    self.confess = message;
    NSInteger ySize = isMine ? padding : padding + 70;
    self.date.text = [DateHandler getDateMessageString:message.lastMessageDate];
    
    //[self.date sizeToFit];
    self.date.backgroundColor = [UIColor clearColor];
    self.content.text = message.content;
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.scrollEnabled = NO;
    //self.content.backgroundColor = [UIColor redColor];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.editable = NO;
    //CGSize textSize = { 260.0, 10000.0 };
	//CGSize size = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
    //                                    constrainedToSize:textSize
    //                                        lineBreakMode:NSLineBreakByWordWrapping];
	//size.width += 10;
    //[self.content sizeToFit];
    [self.content setFrame:CGRectMake(padding / 2, ySize, 216, [self.content sizeThatFits:CGSizeMake(216, FLT_MAX)].height)/*75*/];
    [self.exit addTarget:self action:@selector(exitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.content setFont:[UIFont systemFontOfSize:isMine ? 15 : 14]];

    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };
    NSUInteger centerHeight = isMine ? 90 : 124;
    self.content.center = CGPointMake(self.contentView.frame.size.width / 2 - 41.5, centerHeight);
    
    if (isMine)
    {
        self.likeDislike = [self getLikeDislike];
        [self.smileyButton setImage:(self.likeDislike != nil && self.likeDislike.isLike) ?
         self.smileySelected : self.smiley forState:UIControlStateNormal];
        [self.saddyButton setImage:(self.likeDislike != nil && !self.likeDislike.isLike) ?
         self.saddySelected : self.saddy forState:UIControlStateNormal];
        [self.smileyButton addTarget:self action:@selector(smileyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.saddyButton addTarget:self action:@selector(saddyClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.name.hidden = YES;
        self.profileImage.hidden = YES;
        self.smileyButton.hidden = NO;
        self.saddyButton.hidden = NO;
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
        self.name.hidden = NO;
        self.profileImage.hidden = NO;
        self.smileyButton.hidden = YES;
        self.saddyButton.hidden = YES;
    }
}

- (IBAction)friendClicked:(id)sender
{
    [self.friendsTab friendClicked:self];
}

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat topCorrect = ([self.content bounds].size.height - [self.content contentSize].height * [self.content zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    self.content.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect };

    return self;
}


@end
