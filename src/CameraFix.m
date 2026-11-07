#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <string.h>
static IMP orig[3];
static BOOL check(id x,SEL s,int i){
 if (((BOOL(*)(id,SEL))orig[i])(x,s)) return YES;
 AVCaptureDevice *d=[AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:i==1?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack];
 return d && d.formats.count>0;
}
static BOOL back(id x,SEL s){return check(x,s,0);}
static BOOL front(id x,SEL s){return check(x,s,1);}
static BOOL video(id x,SEL s){return check(x,s,2);}
__attribute__((constructor)) static void start(void){ @autoreleasepool {
 char hw[64]={0},build[64]={0};size_t n=sizeof(hw),m=sizeof(build);
 if(sysctlbyname("hw.machine",hw,&n,0,0)||sysctlbyname("kern.osversion",build,&m,0,0)||strcmp(hw,"iPad7,5")||strcmp(build,"22H124")||![[NSBundle mainBundle].bundleIdentifier isEqual:@"com.apple.camera"])return;
 Class c=NSClassFromString(@"CAMCaptureCapabilities"); const char *names[]={"isBackCameraSupported","isFrontCameraSupported","isVideoSupported"}; IMP hooks[]={(IMP)back,(IMP)front,(IMP)video};
 for(int i=0;i<3;i++){SEL s=sel_registerName(names[i]); Method meth=class_getInstanceMethod(c,s);char t[16]={0};if(!meth||method_getNumberOfArguments(meth)!=2)continue;method_getReturnType(meth,t,sizeof(t));if(strcmp(t,"B")&&strcmp(t,"c"))continue;orig[i]=method_getImplementation(meth);class_replaceMethod(c,s,hooks[i],method_getTypeEncoding(meth));NSLog(@"J71bCameraFix installed %s",names[i]);}
}}
