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
#define padding 20

@interface ConfessCell ()

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) FriendsTab *friendsTab;

@end

@implementation ConfessCell

- (void)awakeFromNib
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)mine friendsTab:(FriendsTab*)friendsTab;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.isMine = mine;
        self.friendsTab = friendsTab;
        
        // Image Initialize
        self.profileImage = [[UIImageView alloc] init];
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.layer.cornerRadius = 20;
        self.profileImage.center = CGPointMake(self.contentView.frame.size.width / 2, 30);
        self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.profileImage];
        
        // Label initialize
        CGRect frame = CGRectMake(0, 0, 100, 30);
        self.name = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.name setFrame:frame];
        //self.name.textAlignment = NSTextAlignmentCenter;
        self.name.center = CGPointMake(self.contentView.frame.size.width / 2, 75);
        [self.contentView addSubview:self.name];
        
        // Text initialize
        self.content = [[UITextView alloc] init];
        [self.contentView addSubview:self.content];
    }
    
    return self;
}

+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message isMine:(BOOL)isMine;
{
    NSString *text = message.content;
	CGSize  textSize = {260.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
	
	size.height += 45.0;
	NSInteger final = isMine ? size.height : 60 + size.height;
    return final;
}

- (void)configureCellWithConfess:(ConfessEntity *)message;
{
    NSInteger ySize = self.isMine ? padding : padding + 70;
    //self.content.center = CGPointMake(self.contentView.frame.size.width / 2, 100);
    self.content.text = message.content;
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.scrollEnabled = NO;
    self.content.backgroundColor = [UIColor clearColor];
    self.content.editable = NO;
    CGSize textSize = { 260.0, 10000.0 };
	CGSize size = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                        constrainedToSize:textSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
	size.width += 10;
    [self.content sizeToFit];
    [self.content setFrame:CGRectMake(padding / 2, ySize, 300, size.height + 15)];
    
    if (!self.isMine)
    {
        [self.name setTitle: message.loginName forState: UIControlStateNormal];
        [self.name setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.name addTarget:self
                      action:@selector(friendClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        self.profileImage.bounds = CGRectMake(0,0,50,50);
        self.profileImage.frame = CGRectMake(132,15,50,50);
        NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:message.url]];
        UIImage *image = [UIImage imageWithData:data];
        self.profileImage.image = image;
        self.name.backgroundColor = [UIColor clearColor];
    }
}

- (IBAction)friendClicked:(id)sender
{
    [self.friendsTab friendClicked:self.tag];
}

@end
