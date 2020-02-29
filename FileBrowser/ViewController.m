//
//  ViewController.m
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ViewController.h"

#import "FileBrowserViewController.h"

#import "Const.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *dataTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加文件";
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [[NSMutableArray alloc] init];
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rbtn addTarget:self action:@selector(onAddButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = rightbtn;
       
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float left = 0.f;
    float top = TITLE_HEIGHT + NAV_HEIGHT;
    CGRect rect = CGRectMake(left, top, width, height - top - TABBAR_EMPTY);
    self.dataTableView = [[UITableView alloc] initWithFrame:rect];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    self.dataTableView.rowHeight = 52.f;
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *))
    {
        self.dataTableView.estimatedRowHeight = 0;
        self.dataTableView.estimatedSectionFooterHeight = 0;
        self.dataTableView.estimatedSectionHeaderHeight = 0;
        self.dataTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.dataTableView];
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
    
    static NSString *sectionsTableIdentifier = @"sectionsTableIdentifierAddFile";
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
    
    NSString *name = [self.dataArr objectAtIndex:row];
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    UIColor *lineColor = [UIColor colorWithRed:0xe7 / 255.f green:0xe7 / 255.f blue:0xe7 / 255.f alpha:1.f];
    float w = tableView.frame.size.width;
    float h = tableView.rowHeight;
    float x = 0, y = 0, interval = 10.f, labelH = 60.f, lineW = 1.f;
    x = interval;
    UIImage *image = [UIImage imageNamed:@"icon_doc"];
    float imgW = image.size.width, imgH = image.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y + (h - imgH) * 0.5, imgW, imgH)];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    x += imgW + interval;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w - x - lineW, labelH)];
    nameLabel.text = [name lastPathComponent];
    nameLabel.font = font;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:nameLabel];
    
    x = 0.f;
    y = h - 2.f;
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 2.f)];
    twoLabel.backgroundColor = lineColor;
    [cell.contentView addSubview:twoLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.dataTableView reloadData];
    }];
    return @[deleteAction];
}

#pragma mark user method

- (void)addFile:(NSDictionary *)dic
{
    bool find = false;
    NSString *name = [dic valueForKey:@"name"];
    for (NSString *path in self.dataArr) {
        if([path compare:name] == NSOrderedSame)
        {
            find = true;
            break;
        }
    }
    if(!find)
    {
        [self.dataArr addObject:name];
        [self.dataTableView reloadData];
    }
    else
    {
        NSLog(@"该文件已经存在!");
    }
}

- (void)onAddButton:(UIButton *)sender
{
    FileBrowserViewController *vc = [[FileBrowserViewController alloc] init];
    [vc setFileBlock:^(NSDictionary * _Nonnull dic) {
        [self addFile:dic];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
