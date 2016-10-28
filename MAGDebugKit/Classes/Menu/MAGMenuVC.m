#import "MAGMenuVC.h"
#import "MAGMenuAction.h"

#import <libextobjc/extobjc.h>


static NSString *const cellReuseID = @"StandardCell";


@interface MAGMenuVC ()

@property (nonatomic) NSMutableArray <id<MAGMenuAction>> *actions;

@end


@implementation MAGMenuVC

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (!self) {
		return nil;
	}
	
	[self initializeMAGMenuVC];
	
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self) {
		return nil;
	}
	
	[self initializeMAGMenuVC];
	
	return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (!self) {
		return nil;
	}
	
	[self initializeMAGMenuVC];
	
	return self;
}

- (void)initializeMAGMenuVC {
	_actions = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseID];
}

#pragma mark - Public methods

- (void)addAction:(id<MAGMenuAction>)action {
	[self.actions addObject:action];
}

- (id<MAGMenuAction>)addBlockAction:(void(^)(void))actionBlock withTitle:(NSString *)actionTitle {
	MAGMenuActionBlock *action = [[MAGMenuActionBlock alloc] init];
	action.block = actionBlock;
	action.title = actionTitle;
	
	[self addAction:action];
	[self.tableView reloadData];
	
	return action;
}

- (id<MAGMenuAction>)addSubscreen:(UIViewController *)subscreen withTitle:(NSString *)actionTitle {
	@weakify(self);
	return [self addBlockAction:^{
			@strongify(self);
			[self.navigationController pushViewController:subscreen animated:YES];
		} withTitle:actionTitle];
}

#pragma mark - Private methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<MAGMenuAction> action = self.actions[indexPath.row];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = action.title;
	cell.detailTextLabel.text = action.subtitle;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	id<MAGMenuAction> action = self.actions[indexPath.row];
	[action perform];
}

@end
