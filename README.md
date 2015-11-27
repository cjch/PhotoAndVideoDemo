# PhotoAndVideoDemo

##	UIImagePickerController

利用present方法展示。可以设置的属性有  

* delegate: 实现UINavigationControllerDelegate, UIImagePickerControllerDelegate  

* sourceType: 相机(拍摄模式)，照片库(默认)，相册
* mediaTypes: 获取的数据类型：默认为图像kUTTypeImage
* allowsEditing  

* videoMaximumDuration: 录制视频的最长时间，单位为s，默认是10分钟  
* videoQuality: 设置视频录制的质量  

* showsCameraControls: 设置为NO，可以添加自定义控制面板cameraOverlayView
* cameraOverlayView
* cameraViewTransform: 设置图像的仿射属性

sourceType为Camera，以下设置才生效
  
* cameraCaptureMode: 获取图像或视频  
* cameraDevice: 选择哪一个摄像头  
* cameraFlashMode: 闪光灯，自动，开，关
