//
//  EditProfVc.m
//  GameOnDonkey
//
//  Created by apple on 04/09/15.
//  Copyright (c) 2015 amstech. All rights reserved.
//

#import "EditProfVc.h"
#import "UIImageView+WebCache.h" 

@interface EditProfVc ()

@end

@implementation EditProfVc
@synthesize arrMenu;
@synthesize strUserId,strEmail;
#pragma mark LifeCycle......................😊▶︎
- (void)viewDidLoad {
    [super viewDidLoad];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    _btnBlur.hidden = true;

    _txtFirstName.enabled = false;
    _txtLastName.enabled = false;
    _txtJobTitle.enabled = false;
    _imgProfPic.image = [UIImage imageNamed:@"defaultProfPic.png"];
    [Utility getRoundView:_imgProfPic andBorderWidth:4 borderColor:[UIColor whiteColor]];
    _changePassView = [[NSBundle mainBundle]loadNibNamed:@"changePassView" owner:self options:nil][0];
    [Utility getViewAfterResize:_changePassView];
    [Utility setRoundCornerForMenuView:_changePopUpView withCornerRadius:30.0];

    NSDictionary *dict = [Utility getObjectForKey:@"LoginInfo"];
    strUserId = [dict valueForKey:@"id"];
    strEmail = [dict valueForKey:@"email"];
    NSString *strFirstName = [dict valueForKey:@"first_name"];
    NSString *strLastName = [dict valueForKey:@"last_name"];
    _lblFullName.text = [NSString stringWithFormat:@"%@ %@",strFirstName,strLastName];
    _lblEmail.text = strEmail;
    _txtFirstName.text = strFirstName;
    _txtLastName.text = strLastName;
   
    
    [self loadDataFromServer];
    
    //[self createSideMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self loadDataFromServer];
    _imgBlurView.hidden = true;
}
#pragma mark Load Profile info..............😊▶︎
-(void)loadDataFromServer
{
    [HUD showProgressHUD];
    NSDictionary *dictParameter=@{@"fromApp":@"1",
                                  @"apptype":@"IPHONE",
                                  @"pagetype": @"VIEW-PROFILE",
                                  @"id":strUserId
                                  };
        [[AFHTTPRequestOperationManager manager] POST:[kBaseURL stringByAppendingString:kViewProfile] parameters:dictParameter
                                               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSDictionary *dictProfInfo = [dictResponse valueForKey:@"Profile_Info"];
          _txtJobTitle.text = [dictProfInfo valueForKey:@"job_tittle"];
         [Utility saveObjectInUserDefaults:dictProfInfo forKey:@"Profile_Info"];

//         _txtFirstName.text = [dictVal valueForKey:@"first_name"];
//         _txtLastName.text = [dictVal valueForKey:@"last_name"];
//         _txtJobTitle.text = [dictVal valueForKey:@"job_tittle"];
         NSString *strImgUrl = [dictProfInfo valueForKey:@"image"];
         NSURL *url = [NSURL URLWithString:strImgUrl];
         [_imgProfPic sd_setImageWithURL:url placeholderImage:nil];
         [HUD hideProgressHUD];
         
     }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"errrrr%@", error);
         [self.view makeToast:@"Network error...please try Again later" duration:2.0 position:ToastPositionCenter];
         [HUD hideProgressHUD];
     }];
    

}
#pragma mark button back.....😊
- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark button menu.....😊
- (IBAction)btnMenuClicked:(id)sender
{
    MainViewController *mainVc = (MainViewController *)(UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    RightViewController *rvc = (RightViewController *)mainVc.rightViewController;
    [rvc.tableView reloadData];

    [kMainViewController showHideRightViewAnimated:true completionHandler:^{
        
//        if (_imgBlurView.hidden) {
//            UIImage *img = [[Utility convertImageFromView:self.view] stackBlur:3];
//            _imgBlurView.image = img;
//            _imgBlurView.hidden = false;
//        }
//        else
//        {
//            _imgBlurView.hidden = true;
//        }
        
    }];
//   [kMainViewController showRightViewAnimated:YES completionHandler:nil];
//    _btnBlur.hidden = false;
//    if (!kMainViewController.rightViewShowing)
//    {
//        _btnBlur.hidden = true;
//    }
}
- (IBAction)btnEditTextClicked:(UIButton *)sender
{
    sender.selected = TRUE;
 [sender setSelected: ![sender isSelected]];
    if (!sender.selected) {
        sender.selected = TRUE;

        switch (sender.tag) {
            case 3333:
                _txtFirstName.enabled =true;
                [_txtFirstName becomeFirstResponder];

                _txtLastName.enabled = false;
                _txtJobTitle.enabled = false;
                break;
            case 3334:
                _txtLastName.enabled = true;
                [_txtLastName becomeFirstResponder];
                _txtFirstName.enabled = false;
                _txtJobTitle.enabled = false;

                break;
            case 3335:
                _txtJobTitle.enabled =true;
                [_txtJobTitle becomeFirstResponder];
                _txtLastName.enabled = false;
                _txtLastName.enabled = false;

                break;
                
                
            default:
                break;
        }

    }
    
   }
-(void)disableAllText
{
    _txtFirstName.enabled = false;
    _txtLastName.enabled = false;
    _txtJobTitle.enabled = false;
}

#pragma mark set Profile picture.............😊►
- (IBAction)btnUploadProfilePicClicked:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take a Photo",
                            @"Upload From Gallery",
                            nil];
    popup.tag = 1;
    popup.delegate = self;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark seect camera or gallery
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self TakeFromCamera];
                    break;
                case 1:
                    [self openGal];
                    break;
                
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
#pragma mark Take from camera.....😊
-(void)TakeFromCamera
{
    UIImagePickerControllerSourceType source = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.delegate = self;
    cameraController.sourceType = source;
    cameraController.allowsEditing = YES;
    [self presentViewController:cameraController animated:YES completion:^{
        //iOS 8 bug.  the status bar will sometimes not be hidden after the camera is displayed, which causes the preview after an image is captured to be black
        if (source == UIImagePickerControllerSourceTypeCamera) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    }];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        //        _imgView.image = nil;
//       // _textView.text = @"Your Text Here...";
//        
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        [imagePicker showsCameraControls];
//        
//        imagePicker.delegate = self;
//        
//        [self presentViewController:imagePicker animated:false completion:^{
//            
//        }];
//    }
//    else
//    {
//        showAlertWithTitle_Content(@"Info",@"Camera unavailable...");
//    }

}
#pragma mark Take from gallery.....😊
-(void)openGal
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:NULL];
 }
#pragma mark - ImagePicker Delegates 😄😄 ▶︎
#pragma mark -

#pragma mark didFinishPickingMediaWithInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:true completion:^
     {
         UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
         _imgProfPic.image = image;
         [Utility getRoundView:_imgProfPic andBorderWidth:1 borderColor:[UIColor whiteColor]];
      //  [self setImageToImageView:image];
     }];
}

#pragma mark imagePickerControllerDidCancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:^
     {
         //        _imgView.image = nil;
         //_textView.text = @"Your Text Here...";
     }];
}
#pragma mark btn change password clicked ........😊▶︎
- (IBAction)btnChangePassClicked:(id)sender
{
    [self.view addSubview:_changePassView];
    [UIView animateWithDuration:1.0 animations:^{
        _changePassView.alpha = 1.0;
    }];

    
}
#pragma mark update password .......😊
- (IBAction)btnUpdatePasswordClicked:(id)sender
{
    [self askForNewPassword];
}
#pragma mark submit new pasword.....😊
-(void)askForNewPassword
{
    if ([_txtNewPass.text isEqualToString:@""] || [_txtConfirmNewPass.text isEqualToString:@""])
    {
        [Utility showAlertWithTitle:@"Alert" msg:@"Please enter all field"];
    }
    else if (![_txtNewPass.text isEqualToString:_txtConfirmNewPass.text])
    {
        [Utility showAlertWithTitle:@"Alert" msg:@"Password and ConfirmPassword should be same"];
    }
    else
    {
        
        [HUD showProgressHUDWithText:@"Loading..."];
        NSDictionary *dictParameter=@{@"fromApp":@"1",
                                      @"apptype":@"IPHONE",
                                      @"pagetype": @"CHANGE-PASSWORD",
                                      @"id":strUserId,
                                      @"password":_txtNewPass.text,
                                      @"confirm_password":_txtConfirmNewPass.text
                                      };
        [[AFHTTPRequestOperationManager manager] POST:[kBaseURL stringByAppendingString:kChangePass] parameters:dictParameter
         
                                              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dictResponse = (NSDictionary *)responseObject;
             
             [HUD hideProgressHUD];
             NSString *strMesage = dictResponse[@"message"];
             showToast(strMesage);
                 if([self.view.subviews containsObject:_changePassView])
                 {[UIView animateWithDuration:1.0 animations:^{
                     _changePassView.alpha = 0.0;
                 }
                                   completion:^(BOOL finished)
                   {
                       [_changePassView removeFromSuperview];
                   }];    }
             
             }

                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             NSLog(@"errrrr%@", error);
             [self.view makeToast:@"Network error...please try Again later" duration:2.0 position:ToastPositionCenter];
             [HUD hideProgressHUD];
         }];
    }
}
#pragma mark update profile info. ..........😊
- (IBAction)btnUpdateProfileClicked:(id)sender
{
    if ([_txtFirstName.text isEqualToString:@""] || [_txtLastName.text isEqualToString:@""])
    {
        [Utility showAlertWithTitle:@"Alert" msg:@"Please enter all field"];
    }
    else
    {
    
    [HUD showProgressHUDWithText:@"Loading..."];
       NSDictionary *dictParameter=@{@"fromApp":@"1",
                                  @"apptype":@"IPHONE",
                                  @"pagetype": @"EDIT-USER",
                                  @"id":strUserId,
                                  @"first_name":_txtFirstName.text,
                                  @"last_name":_txtLastName.text,
                                  @"job_tittle":_txtJobTitle.text,
                                  @"email":strEmail
                                  };
    NSData *imageData = UIImageJPEGRepresentation(_imgProfPic.image, 0.5);
    
    [[AFHTTPRequestOperationManager manager] POST:[kBaseURL stringByAppendingString:kEditProfile]parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"iamge" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSDictionary *dictVal = [dictResponse valueForKey:@"Updated_User_Info"];
//        _txtFirstName.text = [dictVal valueForKey:@"first_name"];
//        _txtLastName.text = [dictVal valueForKey:@"last_name"];
//        _txtJobTitle.text = [dictVal valueForKey:@"job_tittle"];
        NSString *strImgUrl = [dictVal valueForKey:@"image"];
        NSURL *url = [NSURL URLWithString:strImgUrl];
       // [Utility getRoundView:_imgProfPic andBorderWidth:1 borderColor:[UIColor blackColor]];
        [_imgProfPic sd_setImageWithURL:url placeholderImage:nil];
//        NSDictionary * dictUserInfo = dictResponse[@"Profile_Info"];
//        [Utility saveObjectInUserDefaults:dictUserInfo forKey:@"LoginInfo"];
        [HUD hideProgressHUD];
    }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    }
    
    
}


#pragma mark Password view dismiss...😊
- (IBAction)btnChangePassDismissClicked:(id)sender
{
    if([self.view.subviews containsObject:_changePassView])
    {[UIView animateWithDuration:1.0 animations:^{
        _changePassView.alpha = 0.0;
    }
                      completion:^(BOOL finished)
      {
          [_changePassView removeFromSuperview];
      }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
