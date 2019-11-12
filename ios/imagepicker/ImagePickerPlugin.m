//
//  ImagePickerPlugin.m
//  Runner
//
//  Created by 鲁隽彧 on 2019/10/29.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
#import "ImagePickerPlugin.h"
@interface ImagePickerPlugin ()<TZImagePickerControllerDelegate>
@property (strong, nonatomic) FlutterResult result;
@end
@implementation ImagePickerPlugin
{
    TZImagePickerController *imagePickerVc;
}
UIViewController *_viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/image_picker" binaryMessenger:[registrar messenger] ];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    ImagePickerPlugin* instance =[[ImagePickerPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    self.result=result;
    if ([@"getGallery" isEqualToString:call.method]) {
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        // 是否显示可选原图按钮
        imagePickerVc.allowPickingOriginalPhoto = YES;
        // 是否允许显示视频
        imagePickerVc.allowPickingVideo = YES;
        // 是否允许显示图片
        imagePickerVc.allowPickingImage = YES;
    }else if([@"getVideo" isEqualToString:call.method]){
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        // 是否显示可选原图按钮
        imagePickerVc.allowPickingOriginalPhoto = YES;
        // 是否允许显示视频
        imagePickerVc.allowPickingVideo = YES;
        // 是否允许显示图片
        imagePickerVc.allowPickingImage = NO;
    }else if([@"getImage" isEqualToString:call.method]){
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        // 是否显示可选原图按钮
        imagePickerVc.allowPickingOriginalPhoto = YES;
        // 是否允许显示视频
        imagePickerVc.allowPickingVideo = NO;
        // 是否允许显示图片
        imagePickerVc.allowPickingImage = YES;
    }else{
        
    }
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [_viewController presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    //    NSLog(@"%@",photos);
    //    NSMutableArray<FlutterStandardTypedData *> *list = [NSMutableArray array];
    //    for(UIImage *image in photos){
    //        //NSData *imageData = UIImageJPEGRep\\(image);
    //        NSData *imageData = UIImagePNGRepresentation(image);
    //        NSLog(@"%@",imageData);
    //        FlutterStandardTypedData *data=[FlutterStandardTypedData typedDataWithBytes:imageData];
    //        [list addObject:data];
    //    }
    //
    //    self.result(list);
    
    BOOL saveAsPNG = NO;
    NSMutableArray<NSString *> *list = [NSMutableArray array];
    for(UIImage *image in photos){
        NSData *data =
        saveAsPNG ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 1.0);
        NSString *fileExtension = saveAsPNG ? @"image_picker_%@.png" : @"image_picker_%@.jpg";
        NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *tmpFile = [NSString stringWithFormat:fileExtension, guid];
        NSString *tmpDirectory = NSTemporaryDirectory();
        NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
        
        if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]){
            [list addObject:tmpPath];
        }
        
    }
    self.result(list);
}


-(void) tzImagePicker:(Boolean *)flag{
    
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    NSLog(@"%@",asset);
    NSLog(@"%@",coverImage);
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset{
    
}

@end
