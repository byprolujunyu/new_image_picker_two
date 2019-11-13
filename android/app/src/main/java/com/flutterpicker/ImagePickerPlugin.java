package com.flutterpicker;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class ImagePickerPlugin implements MethodChannel.MethodCallHandler {

    static final String METHOD_CALL_IMAGE = "pickImage";
    static final String METHOD_CALL_VIDEO = "pickVideo";
    private static final String METHOD_CALL_RETRIEVE = "retrieve";
    private static final String CHANNEL = "plugins.flutter.io/image_picker";
    private PluginRegistry.Registrar registrar;
    private ImagePickerDelegate delegate;
    private Application.ActivityLifecycleCallbacks activityLifecycleCallbacks;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        if (registrar.activity() == null) {
            return;
        }
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        final ImagePickerDelegate delegate = new ImagePickerDelegate(registrar.activity());
        registrar.addActivityResultListener(delegate);
        registrar.addRequestPermissionsResultListener(delegate);
        final ImagePickerPlugin instance = new ImagePickerPlugin(registrar, delegate);
        channel.setMethodCallHandler(instance);
    }

    ImagePickerPlugin(final PluginRegistry.Registrar registrar, final ImagePickerDelegate delegate) {
        this.registrar = registrar;
        this.delegate = delegate;
        this.activityLifecycleCallbacks = new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

            }

            @Override
            public void onActivityStarted(Activity activity) {

            }

            @Override
            public void onActivityResumed(Activity activity) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    activity.requestPermissions(new String[]{
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.CAMERA},0);
                }
            }

            @Override
            public void onActivityPaused(Activity activity) {

            }

            @Override
            public void onActivityStopped(Activity activity) {

            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                if (activity == registrar.activity()
                        && registrar.activity().getApplicationContext() != null) {
                    ((Application) registrar.activity().getApplicationContext())
                            .unregisterActivityLifecycleCallbacks(
                                    this); // Use getApplicationContext() to avoid casting failures
                }
            }
        };

        if (this.registrar != null && this.registrar.context() != null && this.registrar.context().getApplicationContext() != null) {
            ((Application) this.registrar.context().getApplicationContext()).registerActivityLifecycleCallbacks(
                    this.activityLifecycleCallbacks);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case "getGallery":
                delegate.chooseAllFromGallery(methodCall, result);
                break;
            case "getImage":
                delegate.chooseImageFromGallery(methodCall, result);
                break;
            case "getVideo":
                delegate.chooseVideoFromGallery(methodCall, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
