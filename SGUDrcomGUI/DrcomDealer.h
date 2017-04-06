/**
 * Copyright (C) 2015 Shindo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

@interface DrcomDealer : NSObject
{
    NSString* device;
    NSString* userName;
    NSString* passWord;
    NSString* ip;
    NSString* mac;
}

- (id) initWithNICName: (NSString*)_device userName:(NSString *)_userName passWord:(NSString *)_passWord IPAddress:(NSString*)_ip MacAddress:(NSString*)_mac;
@end