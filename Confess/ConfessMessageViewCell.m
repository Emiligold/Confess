//
//  ConfessMessageViewCell.m
//  Confess
//
//  Created by Noga badhav on 21/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ConfessMessageViewCell.h"
#import "ConfessEntity.h"
#import "DateHandler.h"

#define padding 20

@implementation ConfessMessageViewCell

static UIImage *confessImage;

+ (void)initialize{
    [super initialize];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor lightGrayColor]];
        self.dateLabel.textColor = [UIColor whiteColor];
        
        confessImage = [[UIImage imageNamed:@"GrayConfess"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
        self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
        [self.messageTextView setTextColor:[UIColor whiteColor]];
        self.messageTextView.textAlignment = NSTextAlignmentCenter;
        [self.messageTextView addSubview:self.dateLabel];
        [self.contentView addSubview:self.messageTextView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message
{
    NSString *text = message.text;
    
    
	CGSize  textSize = {260.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
	
	size.height += 45.0;
	return size.height;
}


+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message
{
    NSString *text = message.content;
    
    
	CGSize  textSize = {260.0, 10000.0};
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
	
	size.height += 45.0;
	return size.height;
}


- (void)configureCellWithMessage:(QBChatAbstractMessage *)message
{
    self.messageTextView.text = message.text;
    CGSize textSize = { 260.0, 10000.0 };
    
	CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                        constrainedToSize:textSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
    
    //    NSLog(@"message: %@", message);
    
	size.width += 10;
    
    NSString *time = [DateHandler stringFromDate:message.datetime];
    
    // Left/Right bubble
    if ([LocalStorageService shared].currentUser.ID == message.senderID)
    {
        [self.messageTextView setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        self.messageTextView.text = message.text;
        
        [self.backgroundImageView setFrame:CGRectMake(padding/2, padding+5,
                                                      300, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = [[UIImage imageNamed:@"GrayConfess"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];;
        //self.messageTextView.font = [UIFont systemFontOfSize:18];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        NSString *first = [self.dateLabel.text substringFromIndex:8];
        NSString *second = [time substringFromIndex:8];
        self.messageTextView.textAlignment = NSTextAlignmentCenter;
        
        
        if (self.dateLabel.text == nil || ![[first substringToIndex:2] isEqualToString: [second substringToIndex:2]])
        {
            self.dateLabel.text = [NSString stringWithFormat:@"%@", time];
        }
        else
        {

        }
        
    } else {
        
        [self.messageTextView setFrame:CGRectMake(320-size.width-padding/2, padding+5, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.backgroundImageView setFrame:CGRectMake(320-size.width-padding/2, padding+5,
                                                      self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = confessImage;
        
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.text = [NSString stringWithFormat:@"%lu, %@", (unsigned long)message.senderID, time];
    }

}

- (void)configureCellWithConfess:(ConfessEntity *)message
{
    self.messageTextView.text = message.content;
    CGSize textSize = { 260.0, 10000.0 };
	CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                        constrainedToSize:textSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
	size.width += 10;
    NSString *time = [DateHandler stringFromDate:message.lastMessageDate];
    [self.messageTextView setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
    [self.messageTextView sizeToFit];
    self.messageTextView.text = message.content;
    [self.backgroundImageView setFrame:CGRectMake(padding/2, padding+5,
                                                      300, self.messageTextView.frame.size.height+5)];
    self.backgroundImageView.image = [[UIImage imageNamed:@"GrayConfess"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];;
    //self.messageTextView.font = [UIFont systemFontOfSize:18];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.messageTextView.textAlignment = NSTextAlignmentCenter;
        
    if (self.dateLabel.text == nil || (self.dateLabel.text.length > 8 && ![[[self.dateLabel.text substringFromIndex:8] substringToIndex:2] isEqualToString: [[time substringFromIndex:8] substringToIndex:2]]))
    {
        self.dateLabel.text = [NSString stringWithFormat:@"\n\n%@", time];
    }
    else
    {
    
    }
    
}

@end
