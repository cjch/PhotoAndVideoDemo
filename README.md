# PhotoAndVideoDemo

##	UIImagePickerController

利用present方法展示。可以设置的属性有  

* delegate: 实现UINavigationControllerDelegate, UIImagePickerControllerDelegate  

* sourceType: 相机(拍摄模式)，照片库(默认)，相册
* mediaTypes: 获取的数据类型：默认为图像kUTTypeImage  
kUTTypeImage定义在MobileCoreServices.framework中

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

##AVFoundation
使用AVFoundation拍照，摄像，主要由以下几个步骤：  
	
	1. 建立Session  
	2. 添加Input   
	3. 添加Output  
	4. 配置属性  
	5. 开始获取数据  
	6. 显示捕获的图像和当前状态  
	7. 结束
显示图像时，有两种方式：一种是使用AVCaptureVideoPreviewLayer；另一种是设置代理回调，然后在回调中重建图像，此时重建的图像旋转了90度，这是由于相机传感器的朝向导致的，而AVCaptureVideoPreviewLayer则会自动处理这种情况。
