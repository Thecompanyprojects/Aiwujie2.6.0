//
//  LDAlertOtherDynamicViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/8/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlertOtherDynamicViewController.h"
#import "LDStandardViewController.h"

//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "MGSelectionTagView.h"


@interface LDAlertOtherDynamicViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate> {
    
    NSMutableArray *_selectedPhotos;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

//删除图片时的数组
@property (nonatomic, strong) NSMutableArray *deleteArray;

//原来的独白内容
@property (nonatomic, copy) NSString *oldContent;

//存储缩略图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, copy) NSString *path;

//用于进行操作的水印数组
@property (nonatomic, strong) NSMutableArray *selectedSyArray;

//删除新添加图片时的数组
@property (nonatomic, strong) NSMutableArray *addArray;

//存储水印图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *shuiyinArray;
@property (nonatomic, copy) NSString *shuiyinPath;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation LDAlertOtherDynamicViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (ISIPHONEX) {
        
        self.scrollView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
        
    }else{
        
        self.scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }
    
    _scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetHeight(_scrollView.frame) + 20);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑动态";
    
    if (@available(iOS 11.0, *)) {
        
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _selectedPhotos = [NSMutableArray array];
    
    _selectedSyArray = [NSMutableArray array];
    
    _addArray = [NSMutableArray array];
    
    _pictureArray = [NSMutableArray array];
    
    _shuiyinArray = [NSMutableArray array];
    
    _deleteArray = [NSMutableArray array];

    [self.textLabel sizeToFit];
    
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self createScanData];
    
    [self createButton];

}

-(void)createScanData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/getDynamicdetailNewth"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
    }
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000 && integer != 2001) {
            
           [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
            
            _oldContent = responseObject[@"data"][@"content"];
            
            if ([responseObject[@"data"][@"content"] length] != 0) {
                
                self.textView.text = responseObject[@"data"][@"content"];
                
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)self.textView.text.length];
                
                if (self.textView.text.length == 0) {
                    
                    [self.textLabel setHidden:NO];
                    
                }else{
                    
                    [self.textLabel setHidden:YES];
                }

            }else{
            
                self.textView.text = @"";
                
                self.numberLabel.text = [NSString stringWithFormat:@"%d/10000",0];
                    
                [self.textLabel setHidden:NO];
                    
            }
            
            //用于进行删除添加图片操作的数组
            [_selectedPhotos addObjectsFromArray:responseObject[@"data"][@"pic"]];
            [_selectedSyArray  addObjectsFromArray:responseObject[@"data"][@"sypic"]];
            
            //用于对比是否图片更改的原始数组
            [_pictureArray addObjectsFromArray:responseObject[@"data"][@"pic"]];
            [_shuiyinArray addObjectsFromArray:responseObject[@"data"][@"sypic"]];
            
            //创建collectionView
            [self configCollectionView];
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


//textview代理方法
#pragma mark  textView的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        [self.textLabel setHidden:NO];
        
    }else{
        
        [self.textLabel setHidden:YES];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if (textView.text.length >= 10000) {
            
            textView.text = [textView.text substringToIndex:10000];
            
            self.numberLabel.text = @"10000/10000";
            
        }else{
            
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)textView.text.length];
            
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)configCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (WIDTH - 2 * _margin - 20) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 223, WIDTH - 20, HEIGHT - 217) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    [_scrollView addSubview:_collectionView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        
           [self.view endEditing:YES];
    }

}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_selectedPhotos.count == 9) {
        
        return _selectedPhotos.count;
    }
   
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    if (indexPath.row == _selectedPhotos.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"添加图片"];
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        
        cell.deleteBtn.hidden = YES;
        
    } else {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_selectedPhotos[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.imageView.clipsToBounds = YES;
        
        cell.deleteBtn.hidden = NO;
    }
  
    cell.deleteBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _selectedPhotos.count) {
        
        BOOL showSheet = YES;
        
        if (showSheet) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //拍照  调用相机
                [self takePhoto];
                
            }];
            UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                [self pushImagePickerController];
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
    }else{
        
        __weak typeof(self) weakSelf=self;
        
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:indexPath.row imagesBlock:^NSArray *{
            
            return weakSelf.selectedSyArray;
        }];
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    
    imagePickerVc.cropRect = CGRectMake(0, (HEIGHT - WIDTH)/2, WIDTH, WIDTH);
    
    //    imagePickerVc.maxImagesCount = 1;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            return [self takePhoto];
            
        });
    } else { // 调用相机
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.delegate = self;
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (/* DISABLES CODE */ (YES)) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                            imagePicker.needCircleCrop = NO;
                            //                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                            
                        } else {
                            
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    NSArray *photos = @[image];
    
    [self thumbnaiWithImage:photos andAssets:nil];
    
    [_collectionView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            
            if (alertView.tag == 1) {
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                
            } else {
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                
                [[UIApplication sharedApplication] openURL:privacyUrl];
                
            } else {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    //    NSLog(@"%@",photos);
    [self thumbnaiWithImage:photos andAssets:assets];
}

////上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    _isSelectOriginalPhoto = NO;

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];

    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Api/dynamicPicUpload"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSData *imageData = UIImageJPEGRepresentation(imageArray[0], 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//            NSLog(@"%@",responseObject);

        [_selectedPhotos addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"slimg"]]];
        [_selectedSyArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"syimg"]]];
        
        [_addArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"slimg"]]];
        [_addArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"syimg"]]];

        [_collectionView reloadData];

        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"error --- %@",error.description);
    }];
    
}


#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    [_deleteArray addObject:_selectedPhotos[sender.tag]];
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    
    if (_selectedSyArray.count > 0) {
        
        [_deleteArray addObject:_selectedSyArray[sender.tag]];
        [_selectedSyArray removeObjectAtIndex:sender.tag];
    }
    
    [_collectionView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)buttonOnClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出编辑?"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if (_addArray.count == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            [self deleteAddPicWith:_addArray[0] andSign:0];
            
        }
        
    }];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [action setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [setAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        
    }
    
    [alert addAction:action];
    
    [alert addAction:setAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 * 选择图片后不修改图片,删除新上传的图片
 */
-(void)deleteAddPicWith:(NSString *)filename andSign:(int)i{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"filename":filename};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Api/delPicture"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            if (i + 1 == _addArray.count) {
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self deleteAddPicWith:_addArray[i + 1] andSign:i + 1];
            }
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
//        NSLog(@"%@",error);
    }];
}

/**
 * 更换或添加了照片,点击提交确认修改
 */
-(void)backButtonOnClick:(UIButton *)button{
    
    if (_textView.text.length == 0 && _pictureArray.count == 0) {
        
         [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"不能将全部内容都删除~"];
        
    }else{
        
        NSString *path = [NSString string];
        
        NSString *sypath = [NSString string];
        
        if ([[self getPicpathAndSypathWithArray:_pictureArray] isEqualToString:[self getPicpathAndSypathWithArray:_selectedPhotos]]) {
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            path = [self getPicpathAndSypathWithArray:_pictureArray];
            
            sypath = [self getPicpathAndSypathWithArray:_shuiyinArray];
            
            [self uploadpic:path andSypic:sypath];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            if (_deleteArray.count != 0) {
                
                [self deletePicUrl:_deleteArray[0] andSign:0];
                
            }else{
                
                path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                
                sypath = [self getPicpathAndSypathWithArray:_selectedSyArray];
                
                [self uploadpic:path andSypic:sypath];
            }
        }
    }
}

/**
 * 拼接编辑后的动态图片路径
 */

-(NSString *)getPicpathAndSypathWithArray:(NSMutableArray *)array{
   
    NSString *picPath = [NSString string];
    
    if (array.count == 0) {
        
        picPath = @"";
        
    }else{
        
        if (array.count == 1) {
            
            picPath = [array[0] componentsSeparatedByString:PICHEADURL][1];
            
        }else{
            
            for (int i = 0; i < array.count; i++) {
                
                if (i == 0) {
                    
                    picPath = [array[0] componentsSeparatedByString:PICHEADURL][1];
                    
                }else{
                    
                    picPath = [NSString stringWithFormat:@"%@,%@",picPath,[array[i] componentsSeparatedByString:PICHEADURL][1]];
                }
            }
        }
    }
    
    return picPath;
    
}

/**
 * 删除编辑后的动态图片
 */

-(void)deletePicUrl:(NSString *)filename andSign:(int)i{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"filename":filename};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Api/delPicture"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            if (i + 1 == _deleteArray.count) {
                
                NSString *path = [NSString string];
                
                NSString *sypath = [NSString string];
                
                path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                
                sypath = [self getPicpathAndSypathWithArray:_selectedSyArray];
                
                [self uploadpic:path andSypic:sypath];
                
            }else{
            
                [self deletePicUrl:_deleteArray[i + 1] andSign:i + 1];
            }
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
}

/**
 * 上传编辑后的动态
 */
-(void)uploadpic:(NSString *)path andSypic:(NSString *)sypath{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/editDynamic"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    NSString *content = [NSString string];
    
    if ([_oldContent isEqualToString:self.textView.text]) {
        
        content = _oldContent;
        
    }else{
        
        content = self.textView.text;
    }
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":self.did,@"content":content,@"pic":path,@"sypic":sypath};
    
//    NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        if (integer != 2001) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
             [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
            
            
        }else{
            
           [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"编辑动态成功" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
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
