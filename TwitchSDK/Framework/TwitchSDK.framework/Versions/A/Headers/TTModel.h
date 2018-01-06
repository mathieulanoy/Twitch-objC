//
//  TTModel.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTModel : NSObject

/*!
 * \brief   generate object from an NSDictionary
 * \param   dict    NSDictionary representing the object to create
 * \return  object parsed and created
 */
+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict;

@end
