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

@interface MeTab () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@end

@implementation MeTab

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
    // Do any additional setup after loading the view.
    
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
    self.confesses = [NSMutableArray array];
    self.confessesTableView.delegate = self;
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM CODE_USER_CONFESSES WHERE user_id = %ld",
                       (unsigned long)[LocalStorageService shared].currentUser.ID];
    NSMutableArray *confesses = [[NSMutableArray alloc] initWithArray:[[DBManager shared] loadDataFromDB:query]];
    
    for (NSMutableArray *curr in confesses)
    {
        NSString *confessQuery = [NSString stringWithFormat:@"SELECT * FROM confessEntity where id = %@", curr[2]];
        NSMutableArray *currConfess = [[NSMutableArray alloc] initWithArray:[[DBManager shared] loadDataFromDB:confessQuery]];
        ConfessEntity *confess = [[ConfessEntity alloc] init];
        confess.objectID = [((NSMutableArray*)currConfess[0])[0] integerValue];
        confess.loginName = ((NSMutableArray*)currConfess[0])[2];
        confess.content = ((NSMutableArray*)currConfess[0])[3];
        confess.date = [DateHandler dateFromString:((NSMutableArray*)currConfess[0])[4]];
        confess.facebookID = ((NSMutableArray*)currConfess[0])[1];
        confess.isNew = [((NSMutableArray*)currConfess[0])[5] boolValue];
        [self.confesses addObject:confess];
    }
    
    [self.confessesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];
    self.confessesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperties
{
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    BOOL shouldReceiveTouch = YES;
    
    if (gestureRecognizer == self.tap) {
        shouldReceiveTouch = (touch.view == self.profilePicture);
    }
    return shouldReceiveTouch;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    //NSData *encoded = [self.confesses objectAtIndex:indexPath.row];
    //ConfessEntity *confess = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    ConfessEntity *confess = [self.confesses objectAtIndex:indexPath.row];
    cell.textLabel.text = confess.content;
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:confess.date
     //                                                          dateStyle:NSDateFormatterShortStyle
      //                                                         timeStyle:NSDateFormatterFullStyle];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"GrayConfess.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    //cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_pressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    if (confess.isNew)
    {
        //TODO: Check
        ConfessEntity *confessNew = [[ConfessEntity alloc] init];
        confessNew.objectID = confess.objectID;
        confessNew.loginName = confess.loginName;
        confessNew.facebookID = confess.facebookID;
        confessNew.content = confess.content;
        confessNew.date = confess.date;
        confessNew.isNew = NO;
        //[self.confesses removeObject:encoded];
        [self.confesses removeObject:confess];
        //[self.confesses  addObject:[NSKeyedArchiver archivedDataWithRootObject:confessNew]];
        [self.confesses addObject:confessNew];
        NSString *query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO confessEntity values (%ld,'%@','%@','%@','%@', %d)", (unsigned long)confess.objectID, confess.facebookID, confess.loginName, confess.content, confess.date, [[NSNumber numberWithBool:confess.isNew]intValue]];
        [[DBManager shared] executeQuery:query];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
