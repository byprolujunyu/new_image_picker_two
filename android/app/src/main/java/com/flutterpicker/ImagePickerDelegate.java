package com.flutterpicker;


import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class ImagePickerDelegate implements PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    private MethodChannel.Result pendingResult;
    private MethodCall methodCall;
    private static final String TAG = "ImagePickerDelegate";

    private final Activity activity;

    public ImagePickerDelegate(Activity activity) {
        this.activity = activity;
    }

    public void chooseAllFromGallery(MethodCall methodCall, MethodChannel.Result result) {
        this.methodCall = methodCall;
        this.pendingResult = result;
        SelectorHelper.selectPictures(activity, PictureMimeType.ofAll());
    }

    public void chooseVideoFromGallery(MethodCall methodCall, MethodChannel.Result result) {
        this.methodCall = methodCall;
        this.pendingResult = result;
        SelectorHelper.selectPictures(activity, PictureMimeType.ofVideo());
    }

    public void chooseImageFromGallery(MethodCall methodCall, MethodChannel.Result result) {
        this.methodCall = methodCall;
        this.pendingResult = result;
        SelectorHelper.selectPictures(activity, PictureMimeType.ofImage());
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent data) {
        Log.d(TAG, "onActivityResult: ");
        if (data == null) {
            pendingResult.error("", "", new RuntimeException());
            return false;
        }
        List<String> backPics = new ArrayList<>();
        List<LocalMedia> localMedia = PictureSelector.obtainMultipleResult(data);
        for (LocalMedia m :
                localMedia) {
            backPics.add(m.getPath());
        }
        pendingResult.success(backPics);
        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int i, String[] strings, int[] ints) {
        return false;
    }

    private static class SelectorHelper {


        public static void selectPictures(Activity activity, int mimeType) {

            PictureSelector.create(activity)
                    .openGallery(mimeType)// 全部.PictureMimeType.ofAll()、图片.ofImage()、视频.ofVideo()、音频.ofAudio()
                    // .theme(themeId)// 主题样式设置 具体参考 values/styles   用法：R.style.picture.white.style
                    .maxSelectNum(9)// 最大图片选择数量
                    .minSelectNum(1)// 最小选择数量
                    .imageSpanCount(4)// 每行显示个数
                    .selectionMode(
                            PictureConfig.MULTIPLE)// 多选 or 单选
                    .previewImage(true)// 是否可预览图片
                    .previewVideo(true)// 是否可预览视频
                    .enablePreviewAudio(false) // 是否可播放音频
                    .isCamera(true)// 是否显示拍照按钮
                    .isZoomAnim(true)// 图片列表点击 缩放效果 默认true
                    //.imageFormat(PictureMimeType.PNG)// 拍照保存图片格式后缀,默认jpeg
                    //.setOutputCameraPath("/CustomPath")// 自定义拍照保存路径
                    .enableCrop(false)// 是否裁剪
                    .compress(true)// 是否压缩
                    .synOrAsy(true)//同步true或异步false 压缩 默认同步
                    //.compressSavePath(getPath())//压缩图片保存地址
                    //.sizeMultiplier(0.5f)// glide 加载图片大小 0~1之间 如设置 .glideOverride()无效
                    .glideOverride(160, 160)// glide 加载宽高，越小图片列表越流畅，但会影响列表图片浏览的清晰度
                    //    .withAspectRatio(aspect_ratio_x, aspect_ratio_y)// 裁剪比例 如16:9 3:2 3:4 1:1 可自定义
                    //   .hideBottomControls(cb_hide.isChecked() ? false : true)// 是否显示uCrop工具栏，默认不显示
                    // .isGif(cb_isGif.isChecked())// 是否显示gif图片
                    .freeStyleCropEnabled(true)// 裁剪框是否可拖拽
                    // .circleDimmedLayer(cb_crop_circular.isChecked())// 是否圆形裁剪
                    // .showCropFrame(cb_showCropFrame.isChecked())// 是否显示裁剪矩形边框 圆形裁剪时建议设为false
                    // .showCropGrid(cb_showCropGrid.isChecked())// 是否显示裁剪矩形网格 圆形裁剪时建议设为false
                    // .openClickSound(cb_voice.isChecked())// 是否开启点击声音
                    //  .selectionMedia(selectList)// 是否传入已选图片
                    //.isDragFrame(false)// 是否可拖动裁剪框(固定)
//                        .videoMaxSecond(15)
//                        .videoMinSecond(10)
                    //.previewEggs(false)// 预览图片时 是否增强左右滑动图片体验(图片滑动一半即可看到上一张是否选中)
                    //.cropCompressQuality(90)// 裁剪压缩质量 默认100
                    .minimumCompressSize(100)// 小于100kb的图片不压缩
                    //.cropWH()// 裁剪宽高比，设置如果大于图片本身宽高则无效
                    //.rotateEnabled(true) // 裁剪是否可旋转图片
                    //.scaleEnabled(true)// 裁剪是否可放大缩小图片
                    //.videoQuality()// 视频录制质量 0 or 1
                    //.videoSecond()//显示多少秒以内的视频or音频也可适用
                    //.recordVideoSecond()//录制视频秒数 默认60s
                    .forResult(PictureConfig.CHOOSE_REQUEST);//结果回调onActivityResult code
        }
    }
}
