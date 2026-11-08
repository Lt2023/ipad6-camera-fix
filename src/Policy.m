#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
int main(int argc,char **argv){ @autoreleasepool {
 if(argc!=2)return 2;
 NSString *base=@"/System/Library/LaunchDaemons/com.apple.jetsamproperties.";
 NSString *f=[base stringByAppendingString:@"J71b.plist"], *ref=[base stringByAppendingString:@"J171.plist"];
 NSString *dir=@"/var/lib/local-j71b-camera", *orig=[dir stringByAppendingPathComponent:@"original"], *patched=[dir stringByAppendingPathComponent:@"patched"];
 NSFileManager *fm=NSFileManager.defaultManager;
 NSData *current=[NSData dataWithContentsOfFile:f], *old=[NSData dataWithContentsOfFile:orig], *last=[NSData dataWithContentsOfFile:patched];
 if(!current)return 3;
 if(!strcmp(argv[1],"remove")){
 if(!old&&!last)return 0;
 if(!old||(![current isEqual:old]&&(![current isEqual:last]||![old writeToFile:f atomically:YES])))return 4;
 return [fm removeItemAtPath:dir error:nil]?0:5;
 }
 char hw[64]={0};size_t n=sizeof(hw);
 if(strcmp(argv[1],"configure")||sysctlbyname("hw.machine",hw,&n,NULL,0)||strcmp(hw,"iPad7,5")||NSProcessInfo.processInfo.operatingSystemVersion.majorVersion!=18)return 6;
 if(last&&[current isEqual:last]&&old)return 0;
 if((old&&![current isEqual:old])||(last&&!old))return 7;
 NSMutableDictionary *d=[NSPropertyListSerialization propertyListWithData:current options:NSPropertyListMutableContainers format:nil error:nil];
 NSDictionary *r=[NSDictionary dictionaryWithContentsOfFile:ref]; NSString *key=@"com.apple.cameracaptured";BOOL changed=NO;
 for(NSString *s in @[@"Default",@"Override"]){
 NSMutableDictionary *dest=d[@"Version4"][@"Daemon"][s];NSDictionary *src=r[@"Version4"][@"Daemon"][s][key];
 if(![dest isKindOfClass:NSMutableDictionary.class])return 8;
 if(dest[key])continue;
 if(![src isKindOfClass:NSDictionary.class]||!src.count){fprintf(stderr,"No matching donor policy; no changes applied\n");return 0;}
 dest[key]=src;changed=YES;
 }
 if(!changed)return 0;
 NSData *result=[NSPropertyListSerialization dataWithPropertyList:d format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
 if(!result||![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:@{NSFilePosixPermissions:@0700} error:nil]||(!old&&![current writeToFile:orig atomically:YES])||![result writeToFile:patched atomically:YES])return 9;
 return [result writeToFile:f atomically:YES]?0:10;
}}
