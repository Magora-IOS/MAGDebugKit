#import "MAGSandboxBrowserVC.h"
@import WebKit;


static NSString *const sandboxBrowserCellId = @"sandboxBrowserCellId";


@interface MAGSandboxBrowserVC () <UIDocumentInteractionControllerDelegate>

@property (nonatomic) NSFileManager *fm;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSArray <NSURL *> *items;

@end


@implementation MAGSandboxBrowserVC

- (instancetype)initWithURL:(NSURL *)url {
	self = [self initWithStyle:UITableViewStylePlain];
	if (!self) {
		return nil;
	}

	_fm = [NSFileManager defaultManager];
	
	if (!url) {
		url = [NSURL fileURLWithPath:NSHomeDirectory()];
	}
	
	_url = url;
	
	[self reloadItems];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.url.path.lastPathComponent;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Private methods

- (void)reloadItems {
	NSError *__autoreleasing error = nil;
	self.items = [self.fm contentsOfDirectoryAtURL:self.url includingPropertiesForKeys:@[]
		options:0 error:&error];
	
	if (!self.items) {
		NSLog(@"Error while getting directory contents: %@", error);
	}
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sandboxBrowserCellId];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
			reuseIdentifier:sandboxBrowserCellId];
	}

	NSURL *item = self.items[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];
	
	NSString *fileSize = [NSByteCountFormatter stringFromByteCount:attributes.fileSize
		countStyle:NSByteCountFormatterCountStyleFile];
	
	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	}
	
	NSString *editDate = [df stringFromDate:attributes.fileModificationDate];

	cell.textLabel.text = item.lastPathComponent;
	
	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"directory, edited %@", editDate];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, edited %@", fileSize, editDate];
		cell.accessoryType = UITableViewCellAccessoryDetailButton;
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
	
	NSURL *item = self.items[indexPath.row];
	NSError *__autoreleasing error = nil;
	BOOL removed = [self.fm removeItemAtURL:item error:&error];
	if (removed) {
		[self reloadItems];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else {
		NSLog(@"Error while removing file from sandbox: %@", error);
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSURL *item = self.items[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];
	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:item];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		UIViewController *vc = [[UIViewController alloc] init];
		
		WKWebView *view = [[WKWebView alloc] initWithFrame:vc.view.bounds];
		[vc.view addSubview:view];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[view loadFileURL:item allowingReadAccessToURL:self.url];
//		SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:item];
		[self.navigationController pushViewController:vc animated:YES];
//		UIDocumentInteractionController *interactor = [UIDocumentInteractionController
//			interactionControllerWithURL:item];
//		interactor.delegate = self;
//		[interactor presentPreviewAnimated:YES];
		
//		[interactor presentOptionsMenuFromRect:CGRectZero inView:tableView animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView
	accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSURL *item = self.items[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];
	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:item];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		UIDocumentInteractionController *interactor = [UIDocumentInteractionController
			interactionControllerWithURL:item];
		[interactor presentOptionsMenuFromRect:[tableView rectForRowAtIndexPath:indexPath]
			inView:tableView animated:YES];
	}
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {

	return self.navigationController;
}

@end
