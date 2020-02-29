//
//  AFileUnit.h
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 meliora.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFileUnit : NSObject

@property (nonatomic, strong) NSString *name;//文件名
@property (nonatomic, strong) NSString *path;//文件路径
@property (nonatomic, assign) bool folder;//是否文件夹
@property (nonatomic, assign) bool emptyFolder;//是否空文件夹
@property (nonatomic, assign) bool expand;//是否展开
@property (nonatomic, assign) int level;//显示层级
@property (nonatomic, strong) NSMutableArray *files;//文件列表

+ (NSArray *)loadRoot:(NSString *)path showRoot:(bool)showRoot;

- (void)loadFolder;

@end

NS_ASSUME_NONNULL_END
