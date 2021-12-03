// Autogenerated from Pigeon (v1.0.7), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "messages.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ? error.code : [NSNull null]),
        @"message": (error.message ? error.message : [NSNull null]),
        @"details": (error.details ? error.details : [NSNull null]),
        };
  }
  return @{
      @"result": (result ? result : [NSNull null]),
      @"error": errorDict,
      };
}

@interface BeamsAuthProvider ()
+ (BeamsAuthProvider *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation BeamsAuthProvider
+ (BeamsAuthProvider *)fromMap:(NSDictionary *)dict {
  BeamsAuthProvider *result = [[BeamsAuthProvider alloc] init];
  result.authUrl = dict[@"authUrl"];
  if ((NSNull *)result.authUrl == [NSNull null]) {
    result.authUrl = nil;
  }
  result.headers = dict[@"headers"];
  if ((NSNull *)result.headers == [NSNull null]) {
    result.headers = nil;
  }
  result.queryParams = dict[@"queryParams"];
  if ((NSNull *)result.queryParams == [NSNull null]) {
    result.queryParams = nil;
  }
  result.credentials = dict[@"credentials"];
  if ((NSNull *)result.credentials == [NSNull null]) {
    result.credentials = nil;
  }
  return result;
}
- (NSDictionary *)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.authUrl ? self.authUrl : [NSNull null]), @"authUrl", (self.headers ? self.headers : [NSNull null]), @"headers", (self.queryParams ? self.queryParams : [NSNull null]), @"queryParams", (self.credentials ? self.credentials : [NSNull null]), @"credentials", nil];
}
@end

@interface PusherBeamsApiCodecReader : FlutterStandardReader
@end
@implementation PusherBeamsApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [BeamsAuthProvider fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface PusherBeamsApiCodecWriter : FlutterStandardWriter
@end
@implementation PusherBeamsApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[BeamsAuthProvider class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface PusherBeamsApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PusherBeamsApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PusherBeamsApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PusherBeamsApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PusherBeamsApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    PusherBeamsApiCodecReaderWriter *readerWriter = [[PusherBeamsApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


void PusherBeamsApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PusherBeamsApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.start"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startInstanceId:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(startInstanceId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_instanceId = args[0];
        FlutterError *error;
        [api startInstanceId:arg_instanceId error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.addDeviceInterest"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(addDeviceInterestInterest:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(addDeviceInterestInterest:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_interest = args[0];
        FlutterError *error;
        [api addDeviceInterestInterest:arg_interest error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.removeDeviceInterest"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(removeDeviceInterestInterest:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(removeDeviceInterestInterest:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_interest = args[0];
        FlutterError *error;
        [api removeDeviceInterestInterest:arg_interest error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.getDeviceInterests"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getDeviceInterestsWithError:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(getDeviceInterestsWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSArray<NSString *> *output = [api getDeviceInterestsWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.setDeviceInterests"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setDeviceInterestsInterests:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(setDeviceInterestsInterests:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NSString *> *arg_interests = args[0];
        FlutterError *error;
        [api setDeviceInterestsInterests:arg_interests error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.clearDeviceInterests"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(clearDeviceInterestsWithError:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(clearDeviceInterestsWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api clearDeviceInterestsWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.onInterestChanges"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(onInterestChangesCallbackId:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(onInterestChangesCallbackId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_callbackId = args[0];
        FlutterError *error;
        [api onInterestChangesCallbackId:arg_callbackId error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.setUserId"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setUserIdUserId:provider:callbackId:error:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(setUserIdUserId:provider:callbackId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_userId = args[0];
        BeamsAuthProvider *arg_provider = args[1];
        NSString *arg_callbackId = args[2];
        FlutterError *error;
        [api setUserIdUserId:arg_userId provider:arg_provider callbackId:arg_callbackId error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.clearAllState"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(clearAllStateWithError:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(clearAllStateWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api clearAllStateWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PusherBeamsApi.stop"
        binaryMessenger:binaryMessenger
        codec:PusherBeamsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopWithError:)], @"PusherBeamsApi api (%@) doesn't respond to @selector(stopWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api stopWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface CallbackHandlerApiCodecReader : FlutterStandardReader
@end
@implementation CallbackHandlerApiCodecReader
@end

@interface CallbackHandlerApiCodecWriter : FlutterStandardWriter
@end
@implementation CallbackHandlerApiCodecWriter
@end

@interface CallbackHandlerApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation CallbackHandlerApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[CallbackHandlerApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[CallbackHandlerApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *CallbackHandlerApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    CallbackHandlerApiCodecReaderWriter *readerWriter = [[CallbackHandlerApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


@interface CallbackHandlerApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation CallbackHandlerApi
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}

- (void)handleCallbackCallbackId:(NSString *)arg_callbackId callbackName:(NSString *)arg_callbackName args:(NSArray *)arg_args completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.CallbackHandlerApi.handleCallback"
      binaryMessenger:self.binaryMessenger
      codec:CallbackHandlerApiGetCodec()];
  [channel sendMessage:@[arg_callbackId, arg_callbackName, arg_args] reply:^(id reply) {
    completion(nil);
  }];
}
@end
