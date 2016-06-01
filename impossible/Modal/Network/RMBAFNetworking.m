//
//  RMBAFNetworking.m
//  impossible
//
//  Created by Blessed on 16/5/3.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
//#define kImageUploadPath @"http://127.0.0.1:8080/upload"

#import "RMBAFNetworking.h"
#import "AFNetworking.h"

static RMBAFNetworking *g_rmbAFNetworking = nil;

@implementation RMBAFNetworking

+ (instancetype)sharedInstance {
    @synchronized (self) {
        if (g_rmbAFNetworking == nil) {
            g_rmbAFNetworking = [[self alloc] init];
        }
    }
    return g_rmbAFNetworking;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)saveImageToServerWithFileName:(NSString*)imageName url:(NSString*)url method:(NSString*)method andPath:(NSString*)path completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:imageName mimeType:@"image/x-png" error:nil];
    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          handler(error.localizedDescription,nil);
                      } else {
                          handler(nil,[responseObject objectForKey:@"response"]);
                      }
                  }];
    
    [uploadTask resume];

}

- (void)downloadUserHeadImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler {
    NSString *sandboxPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    BOOL imageCheck = [[NSFileManager defaultManager] fileExistsAtPath:sandboxPath];
    if (imageCheck) {
        NSLog(@"已有缓存记录");
        //沙盒文件中有缓存 则直接采用沙盒文件中的图片
        handler(nil,sandboxPath);
    } else {
        //沙盒文件中没有缓存 则开进程下载图片
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
        NSString *url = [[kUserHeadImagePath stringByAppendingString:@"/"] stringByAppendingString:imageName];
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"File downloaded to: %@", filePath);
            if (error) {
                handler(error.localizedFailureReason,nil);
            } else {
                NSLog(@"直接从网上下载，并缓存");
                handler(nil,filePath);
            }
        }];
        [downloadTask resume];
    }
}

- (void)downloadIndexActivityImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler {
    NSString *sandboxPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    BOOL imageCheck = [[NSFileManager defaultManager] fileExistsAtPath:sandboxPath];
    if (imageCheck) {
        NSLog(@"已有缓存记录");
        //沙盒文件中有缓存 则直接采用沙盒文件中的图片
        handler(nil,sandboxPath);
    } else {
        //沙盒文件中没有缓存 则开进程下载图片
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *url = [[kIndexActivityPath stringByAppendingString:@"/"] stringByAppendingString:imageName];
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"File downloaded to: %@", filePath);
            if (error) {
                handler(error.localizedFailureReason,nil);
            } else {
                NSLog(@"直接从网上下载，并缓存");
                handler(nil,filePath);
            }
        }];
        [downloadTask resume];
    }
}

- (void)downloadCarouselImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler {
    NSString *sandboxPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    BOOL imageCheck = [[NSFileManager defaultManager] fileExistsAtPath:sandboxPath];
    if (imageCheck) {
        NSLog(@"已有缓存记录");
        //沙盒文件中有缓存 则直接采用沙盒文件中的图片
        handler(nil,sandboxPath);
    } else {
        //沙盒文件中没有缓存 则开进程下载图片
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *url = [[kIndexCarousel stringByAppendingString:@"/"] stringByAppendingString:imageName];
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"File downloaded to: %@", filePath);
            if (error) {
                handler(error.localizedFailureReason,nil);
            } else {
                NSLog(@"直接从网上下载，并缓存");
                handler(nil,filePath);
            }
        }];
        [downloadTask resume];
    }
}

- (void)downloadHouseImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler {
    NSString *sandboxPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    BOOL imageCheck = [[NSFileManager defaultManager] fileExistsAtPath:sandboxPath];
    if (imageCheck) {
        NSLog(@"已有缓存记录");
        //沙盒文件中有缓存 则直接采用沙盒文件中的图片
        handler(nil,sandboxPath);
    } else {
        //沙盒文件中没有缓存 则开进程下载图片
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *url = [[kHouseImagePath stringByAppendingString:@"/"] stringByAppendingString:imageName];
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"File downloaded to: %@", filePath);
            if (error) {
                handler(error.localizedFailureReason,nil);
            } else {
                NSLog(@"直接从网上下载，并缓存");
                handler(nil,filePath);
            }
        }];
        [downloadTask resume];
    }
}

@end
