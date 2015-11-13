//
//  FacebookCell.m
//  Confess
//
//  Created by Noga badhav on 24/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookCell.h"
#import "ConfessEntity.h"

@interface FacebookCell()

@property (nonatomic, strong) FriendsTab *friendsTab;
@property (nonatomic, strong) NSMutableDictionary *urlToData;

@end

@implementation FacebookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier friendsTab:(FriendsTab *)friendsTab;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.friendsTab = friendsTab;
        self.urlToData = [[NSMutableDictionary alloc] init];
        
        // Image initialize
        self.profileImage = [[UIImageView alloc] init];
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.layer.cornerRadius = 20;
        self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.profileImage];
        
        // Label initialize
        //CGRect frame = CGRectMake(0, 0, 220, 30);
        self.name = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[self.name setFrame:frame];
        //self.name.textAlignment = NSTextAlignmentCenter;
        [self.name setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.name];
        
        // Text initialize
        self.content = [[UITextView alloc] init];
        [self.contentView addSubview:self.content];

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
}

- (void)configureCellWithFriend:(NSDictionary<FBGraphUser> *)facebookFriend
{
    NSString *url = [FacebookCell getUserUrl:facebookFriend];
    ConfessEntity *confess = [self.friendsTab.urlOrIdToDialog objectForKey:url];
    
    if (confess != nil)
    {
        NSInteger ySize = 20 + 70;
        //self.content.center = CGPointMake(self.contentView.frame.size.width / 2, 100);
        self.content.text = confess.content;
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
        [self.content setFrame:CGRectMake(20 / 2, ySize, 300, size.height + 15)];
    }
    else
    {
        self.content.text = @"";
    }
    
    [self.name setTitle: facebookFriend.name forState: UIControlStateNormal];
    [self.name sizeToFit];
    self.profileImage.bounds = CGRectMake(0,0,50,50);
    self.profileImage.frame = CGRectMake(20,20,50,50);
    NSData *data;
    UIImage *image;
    
    if (false)//[self.urlToData objectForKey:url] != nil)
    {
        data = [self.urlToData objectForKey:url];
    }
    else
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data,
                                                   NSError * error) {
                                   if (!error){
                                       self.profileImage.image = [UIImage imageWithData:data];
                                       // do whatever you want with image
                                   }
                                   
                               }];
        
        //data = [NSData dataWithContentsOfURL : [NSURL URLWithString:url]];
        //[self.urlToData setObject:data forKey:url];
    }
    
    //UIImage *image = [UIImage imageWithData:data];
    self.name.center = CGPointMake(self.contentView.frame.size.width / 2, 85);
    //self.profileImage.image = image;
    self.profileImage.center = CGPointMake(self.contentView.frame.size.width / 2, 50);
    [self.name addTarget:self
                  action:@selector(friendClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    //cell.imageView.image = [UIImage imageWithData:data];
    //CGRect bounds;
    //bounds.origin = CGPointZero;
    //bounds.size = image.size;
    //self.profileImage.bounds = bounds;
    //self.profileImage.image = image;
    //self.profileImage.frame = CGRectMake(20, 20, image.size.width, image.size.height);
    //self.profileImage.center = self.profileImage.superview.center;
    //self.profileImage.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.profileImage.layer.masksToBounds = YES;
    //UIImage *newImage = [FacebookCell imageWithImage:image scaledToSize:newSize];
    //self.profileImage.image = image;
    //this line will do it!
    //self.profileImage.frame = CGRectMake(20, 20, newImage.size.width, newImage.size.height);
    //self.profileImage.clipsToBounds = YES;
    //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.cornerRadius = 20;
    //self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
}

+(NSString*)getUserUrl:(NSDictionary<FBGraphUser>*)user
{
    FBGraphObject *picture = [user objectForKey:@"picture"];
    FBGraphObject *check = [picture objectForKey:@"data"];
    return [check objectForKey:@"url"];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)friendClicked:(id)sender
{
    [self.friendsTab friendClicked:self];
}

@end
