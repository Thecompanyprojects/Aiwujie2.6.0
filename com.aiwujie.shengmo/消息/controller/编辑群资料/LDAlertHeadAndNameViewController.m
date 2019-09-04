//
//  LDAlertHeadAndNameViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlertHeadAndNameViewController.h"
#import "LDAlertNameViewController.h"

@interface LDAlertHeadAndNameViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@property(nonatomic,copy) NSString *oldHeadUrl;

@end

@implementation LDAlertHeadAndNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"群组信息";
    
    self.headView.layer.cornerRadius = 25;
    self.headView.clipsToBounds = YES;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headUrl]] placeholderImage:[UIImage imageNamed:@"群默认头像"]];
    
    _oldHeadUrl = self.headUrl;
    
    self.groupNameLabel.text = self.groupName;
}
- (IBAction)headButtonClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //拍照  调用相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];//显示出来
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [photoAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [cameraAction setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark  imagePicker的代理方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    _headView.image = img;
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.1);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Api/fileUpload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //                NSLog(@"%@",responseObject);
        _headUrl = responseObject[@"data"];
        
        [self alertData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)alertData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/editGroupInfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"group_pic":_headUrl};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
        
            if (![_oldHeadUrl isEqualToString:_headUrl]) {
                
                [self deletePicUrl:_oldHeadUrl];
                
                _oldHeadUrl = _headUrl;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];
}

-(void)deletePicUrl:(NSString *)filename{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"filename":filename};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Api/delPicture"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            NSLog(@"删除成功");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    
}


- (IBAction)groupNameButtonClick:(id)sender {
    
    LDAlertNameViewController *nvc = [[LDAlertNameViewController alloc] init];
    
    nvc.block = ^(NSString *name){
    
        self.groupNameLabel.text = name;
        
        self.groupName = name;
    };
    
    nvc.groupName = self.groupName;
    
    nvc.gid = self.gid;
    
    [self.navigationController pushViewController:nvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
