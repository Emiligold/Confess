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
#define padding 20

@implementation ConfessCell

- (void)awakeFromNib
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Image Initialize
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 45, 45)];
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.layer.cornerRadius = 20;
        self.profileImage.center = CGPointMake(self.contentView.frame.size.width / 2, 30);
        [self.contentView addSubview:self.profileImage];
        
        // Label initialize
        CGRect frame = CGRectMake(0, 0, 100, 30);
        self.name = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.name setFrame:frame];
        //self.name.textAlignment = NSTextAlignmentCenter;
        self.name.center = CGPointMake(self.contentView.frame.size.width / 2, 60);
        [self.contentView addSubview:self.name];
        
        // Text initialize
        self.content = [[UITextView alloc] init];
        [self.contentView addSubview:self.content];
    }
    
    return self;
}

+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message
{
    NSString *text = message.content;
	CGSize  textSize = {260.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
	
	size.height += 45.0;
	return 50 + size.height;
}

- (void)configureCellWithConfess:(ConfessEntity *)message
{
    [self.name setTitle: message.loginName forState: UIControlStateNormal];
    [self.name setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.name addTarget:self
               action:@selector(friendClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:message.url]];
    self.profileImage.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[UIImage imageWithData: data] CGImage],CGRectMake(20, 20, 45, 45) )];
    //self.content.center = CGPointMake(self.contentView.frame.size.width / 2, 100);
    self.content.text = message.content;
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.scrollEnabled = NO;
    self.content.backgroundColor = [UIColor clearColor];
    self.content.editable = NO;
    self.content.text = message.content;
    CGSize textSize = { 260.0, 10000.0 };
	CGSize size = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                        constrainedToSize:textSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
	size.width += 10;
    [self.content sizeToFit];
    [self.content setFrame:CGRectMake(padding / 2, padding + 50, 300, size.height + 15)];
}

- (IBAction)friendClicked:(id)sender
{
}

@end
