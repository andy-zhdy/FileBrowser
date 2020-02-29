//
//  FileBrowserViewController.m
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 meliora.cn. All rights reserved.
//

#import "FileBrowserViewController.h"

#import "Const.h"

#import "AFileUnit.h"

@interface FileBrowserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) fileParamBlock doneBlock;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *dataTableView;

@end

@implementation FileBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"文件浏览器";
    
    NSLog(@"path = %@", [self getDocuments]);
    self.dataArr = [[NSMutableArray alloc] initWithArray:[AFileUnit loadRoot:[self getDocuments] showRoot:true]];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float left = 0.f, top = TITLE_HEIGHT + NAV_HEIGHT;
    float tableH = height - top - TABBAR_EMPTY;
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(left, top, width, tableH) style:UITableViewStylePlain];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    self.dataTableView.rowHeight = 51.f;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.dataTableView];
    if (@available(iOS 11.0, *))
    {
        self.dataTableView.estimatedRowHeight = 0;
        self.dataTableView.estimatedSectionFooterHeight = 0;
        self.dataTableView.estimatedSectionHeaderHeight = 0;
        self.dataTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)dealloc
{
    NSLog(@"----dealloc FileBrowerViewController----");
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if(row > self.dataArr.count)
        return [UITableViewCell new];
    
    static NSString *sectionsTableIdentifier = @"sectionsTableIdentifierFileBrowser";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionsTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionsTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    AFileUnit *obj = [self.dataArr objectAtIndex:row];
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    UIColor *lineColor = [UIColor colorWithRed:0xe7 / 255.f green:0xe7 / 255.f blue:0xe7 / 255.f alpha:1.f];
    float rowW = tableView.frame.size.width;
    float rowH = tableView.rowHeight;
    float x = 0, y = 0, interval = 10.f, labelH = 50.f, lineH = 1.f;
    x = interval + (interval * obj.level);
    UIImage *image = nil;
    if(obj.folder)
    {
        if(obj.emptyFolder)
            image = [UIImage imageNamed:@"folder_empty"];
        else
            image = [UIImage imageNamed:@"folder"];
    }
    else
        image = [UIImage imageNamed:@"file"];
    float imgW = image.size.width, imgH = image.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y + (rowH - imgH) * 0.5, imgW, imgH)];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    x += imgW + interval;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, rowW - x - interval, labelH)];
    nameLabel.text = obj.name;
    nameLabel.font = font;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:nameLabel];
    
    x = interval + (interval * obj.level);
    y += labelH;
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, rowW - x - interval, lineH)];
    twoLabel.backgroundColor = lineColor;
    [cell.contentView addSubview:twoLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFileUnit *obj = [self.dataArr objectAtIndex:indexPath.row];
    if(obj.folder)
    {
        if(obj.expand)
        {
            [self closeRows:obj];
        }
        else
        {
            [obj loadFolder];
            if(obj.files.count > 0)
            {
                obj.expand = true;
                NSUInteger count = indexPath.row + 1;
                NSMutableArray *cells = [[NSMutableArray alloc] init];
                for (AFileUnit *item in obj.files)
                {
                    [cells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [self.dataArr insertObject:item atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }
    else
    {
        if(self.doneBlock)
            self.doneBlock([NSDictionary dictionaryWithObjectsAndKeys:obj.path, @"name", nil]);
        [self.navigationController popViewControllerAnimated:YES];
        //NSLog(@"%@,%@", obj.name, obj.path);
    }
}

#pragma mark user method

- (void)closeRows:(AFileUnit *)item
{
    for (AFileUnit *obj in item.files)
    {
        item.expand = false;
        NSUInteger indexToRemove = [self.dataArr indexOfObjectIdenticalTo:obj];
        if(obj.files.count > 0)
            [self closeRows:obj];
        
        if([self.dataArr indexOfObjectIdenticalTo:obj] != NSNotFound)
        {
            [self.dataArr removeObjectIdenticalTo:obj];
            [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (NSString *)getDocuments
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (void)setFileBlock:(fileParamBlock)block
{
    self.doneBlock = block;
}

@end
