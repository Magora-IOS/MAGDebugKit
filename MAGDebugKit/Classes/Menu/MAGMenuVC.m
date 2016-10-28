#import "MAGMenuVC.h"
#import "MAGMenuAction.h"


static NSString *const cellReuseID = @"StandardCell";


@interface MAGMenuVC ()

@property (nonatomic) NSMutableArray <id<MAGMenuAction>> *actions;

@end


@implementation MAGMenuVC

#pragma mark - Lifecycle

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
}

- (id<MAGMenuAction>)addSubscreen:(UIViewController *)subscreen withTitle:(NSString *)actionTitle {
	@weakify(self);
	[self addBlockAction:^{
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
	cell.textLabel.text = action.title;
	cell.detailTextLabel.text = action.subtitle;
	
	return cell;
}

@end
