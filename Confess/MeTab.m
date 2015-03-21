//
//  MeTab.m
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "MeTab.h"
#import "ConfessEntity.h"
#import "DBManager.h"
#import "DateHandler.h"
#import "DBServices.h"
#import "CodeUrls.h"
#import "ConfessCell.h"
#import "ColorsHandler.h"

@interface MeTab () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@end

@implementation MeTab

#define padding 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(220, 72);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t downloadQuqeue = dispatch_queue_create("download", NULL);
    dispatch_async(downloadQuqeue, ^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
        });
    });

    self.name.text = self.nameText;
    self.profilePicture.profileID = self.profileID;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 2;
    self.profilePicture.clipsToBounds = YES;
    self.isFullScreen = false;
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen)];
    self.tap.delegate = self;
    self.tabBarController.tabBar.hidden = NO;
    self.confessesTableView.delegate = self;
    self.confesses = [DBServices getMyConfesses];
    //[self.confessesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];
    //self.confessesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [ColorsHandler lightBlueColor];
    self.titleScroll.backgroundColor = [UIColor colorWithRed:(199/255.0) green:(221/255.0) blue:(236/255.0) alpha:1];
    self.confessesTableView.backgroundColor = [ColorsHandler lightBlueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperties
{
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.confesses = [DBServices getMyConfesses];
    [self.confessesTableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    BOOL shouldReceiveTouch = YES;
    
    if (gestureRecognizer == self.tap) {
        shouldReceiveTouch = (touch.view == self.profilePicture);
    }
    return shouldReceiveTouch;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ConfessCell heightForCellWithConfess:self.confesses[indexPath.row] isMine:YES];
}

-(void)imgToFullScreen{
    if (!self.isFullScreen) {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            //save previous frame
            self.prevFrame = self.profilePicture.frame;
            self.prevFrameButton = self.imageButton.frame;
            [self.profilePicture setFrame:[[UIScreen mainScreen] bounds]];
            [self.imageButton setFrame:[[UIScreen mainScreen] bounds]];
            self.confessesTableView.hidden = YES;
        }completion:^(BOOL finished){
            self.isFullScreen = true;
            self.tabBarController.tabBar.hidden = YES;
        }];
        return;
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            [self.profilePicture setFrame:self.prevFrame];
            [self.imageButton setFrame:self.prevFrameButton];
        }completion:^(BOOL finished){
            self.isFullScreen = false;
            self.tabBarController.tabBar.hidden = NO;
            self.confessesTableView.hidden = NO;
        }];
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)imageClicked:(id)sender
{
    [self imgToFullScreen];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.confesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"rowCell";
    //CGSize textSize = { 260.0, 10000.0 };
    ConfessCell *cell = [self.confessesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ConfessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier isMine:YES friendsTab:nil meTab:self];
    }
    
    ConfessEntity *confess = self.confesses[indexPath.row];
    //cell.textLabel.text = confess.content;
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:confess.date
     //                                                          dateStyle:NSDateFormatterShortStyle
      //                                                         timeStyle:NSDateFormatterFullStyle];
    //CGSize size = [cell.textLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:23]
    //                                    constrainedToSize:textSize
    //                                        lineBreakMode:NSLineBreakByWordWrapping];
	//size.width += 10;
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"GrayConfess.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    //[cell.textLabel setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
    //[cell.backgroundView setFrame:CGRectMake(padding/2, padding+5,
    //                                              300, cell.textLabel.frame.size.height+5)];
    //cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_pressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    ConfessEntity *confessNew = [[ConfessEntity alloc] init];
    
    if (confess.isNew)
    {
        
        confessNew.objectID = confess.objectID;
        confessNew.toName = confess.toName;
        confessNew.url = confess.url;
        confessNew.content = confess.content;
        confessNew.lastMessageDate = confess.lastMessageDate;
        confessNew.isNew = NO;
        confessNew.toFacebookID = confess.toFacebookID;
        NSString *confessId = [NSString stringWithFormat:@"%lu", (unsigned long)confess.objectID];
        [[DBManager shared] mergeQuery:tConfessEntity table:
         [[NSMutableArray alloc] initWithObjects:confessId, [NSString stringWithFormat: @"'%@'", confess.toName], [NSString stringWithFormat:@"%d", confess.url.objectID], [NSString stringWithFormat:@"'%@'", confess.content], [NSString stringWithFormat:@"'%@'", [DateHandler stringFromDate:confess.lastMessageDate]], @"0", @"", nil]];
        [self.confesses removeObject:confess];
        [self.confesses addObject:confessNew];
    }
    
    [cell configureCellWithConfess:confessNew];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [ColorsHandler lightBlueColor];
    return cell;
}

@end
