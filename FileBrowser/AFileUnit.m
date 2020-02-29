//
//  AFileUnit.m
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 meliora.cn. All rights reserved.
//

#import "AFileUnit.h"

@implementation AFileUnit

+ (NSArray *)loadRoot:(NSString *)path showRoot:(bool)showRoot
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL dir;
    [fm fileExistsAtPath:path isDirectory:&dir];
    if(dir == YES) {
        if(showRoot) {
            AFileUnit *obj = [[AFileUnit alloc] init];
            obj.name = [path lastPathComponent];
            obj.level = 0;
            obj.path = path;
            obj.folder = true;
            obj.emptyFolder = true;
            obj.expand = false;
            obj.files = [[NSMutableArray alloc] init];
            
            NSArray *tempArr = [fm contentsOfDirectoryAtPath:path error:nil];
            if(tempArr.count > 0)
                obj.emptyFolder = false;
            [dataArr addObject:obj];
        }
        else
        {
            NSArray *arr = [fm contentsOfDirectoryAtPath:path error:nil];
            for (NSString *name in arr) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, name];
                AFileUnit *obj = [[AFileUnit alloc] init];
                obj.name = name;
                obj.level = 0;
                obj.path = filePath;
                [dataArr addObject:obj];
                
                BOOL dir;
                [fm fileExistsAtPath:filePath isDirectory:&dir];
                if(dir) {
                    obj.folder = true;
                    obj.emptyFolder = true;
                    obj.expand = false;
                    obj.files = [[NSMutableArray alloc] init];
                    
                    NSArray *tempArr = [fm contentsOfDirectoryAtPath:filePath error:nil];
                    if(tempArr.count > 0)
                        obj.emptyFolder = false;
                } else {
                    obj.folder = false;
                }
            }
        }
    }
    return dataArr;
}

- (void)loadFolder
{
    [self.files removeAllObjects];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arr = [fm contentsOfDirectoryAtPath:self.path error:nil];
    if(arr.count > 0)
        self.emptyFolder = false;
    else
        self.emptyFolder = true;
    for (NSString *fileName in arr) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", self.path, fileName];
        AFileUnit *obj = [[AFileUnit alloc] init];
        obj.name = fileName;
        obj.level = self.level + 1;
        obj.path = filePath;
        [self.files addObject:obj];
        
        BOOL dir;
        [fm fileExistsAtPath:filePath isDirectory:&dir];
        if(dir){
            obj.folder = true;
            obj.emptyFolder = true;
            obj.expand = false;
            obj.files = [[NSMutableArray alloc] init];
            
            NSArray *tempArr = [fm contentsOfDirectoryAtPath:filePath error:nil];
            if(tempArr.count > 0)
                obj.emptyFolder = false;
        } else {
            obj.folder = false;
        }
    }
}

@end
