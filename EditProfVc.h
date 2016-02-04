//
//  EditProfVc.h
//  GameOnDonkey
//
//  Created by apple on 04/09/15.
//  Copyright (c) 2015 amstech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfVc : UIViewController<UIActionSheetDelegate,UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBlur;

@property (strong, nonatomic) IBOutlet UIButton *btnProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfPic;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtJobTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic)NSString *strUserId, *strEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblFullName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgBlurView;

@property (strong, nonatomic)NSArray *arrMenu;

@property (strong, nonatomic) IBOutlet UIView *changePassView;
@property (strong, nonatomic) IBOutlet UIView *changePopUpView;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPass;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmNewPass;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdatePass
;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UIButton *btnChangePass;
- (IBAction)btnChangePassClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChangePassDismiss;
@property (strong, nonatomic) IBOutlet UIButton *btnEditFirstName;
@property (strong, nonatomic) IBOutlet UIButton *btnEditLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnJobTitle;

- (IBAction)btnChangePassDismissClicked:(id)sender;

- (IBAction)btnUpdatePasswordClicked:(id)sender;

- (IBAction)btnBackClicked:(id)sender;

- (IBAction)btnMenuClicked:(id)sender;

- (IBAction)btnUploadProfilePicClicked:(id)sender;

- (IBAction)btnUpdateProfileClicked:(id)sender;

- (IBAction)btnEditTextClicked:(UIButton*)sender;


@end
