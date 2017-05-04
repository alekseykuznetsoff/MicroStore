//
//  CartViewController.m
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "MSCartViewController.h"
#import "MSCartCell.h"

@interface MSCartViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTotal;

@property (nonatomic) NSFetchedResultsController *FRC;

- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MSCartViewController

#pragma mark - --Init
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLabelTotal];
}

#pragma mark - --Setters&Getters
- (NSFetchedResultsController *)FRC
{
    if (!_FRC) {
        _FRC = [MSCart MR_fetchAllSortedBy:@"product.name"
                                 ascending:YES
                             withPredicate:nil
                                   groupBy:nil
                                  delegate:self];
    }
    return _FRC;
}

#pragma mark - --Buttons
- (IBAction)closeAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAction:(UIButton *)sender
                forEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        MSCart *cart = [self.FRC objectAtIndexPath:indexPath];
        MSStock *stock = [MSStock MR_findFirstByAttribute:@"product" withValue:cart.product];
        stock.amount ++;
        cart.amount --;
        if (cart.amount == 0) {
            [cart MR_deleteEntity];
            
            if (self.FRC.fetchedObjects.count <= 1) {
                [self closeAction:nil];
            }
        }
    }
}

#pragma mark - --Logic
- (void)updateLabelTotal
{
    NSArray *shoppingCart = self.FRC.fetchedObjects;
    if (shoppingCart.count == 0) {
        self.labelTotal.text = @"Cart empty";
    } else {
        NSNumber *totalSum = [shoppingCart valueForKeyPath: @"@sum.cost"];
        NSNumber *totalAmount = [shoppingCart valueForKeyPath: @"@sum.amount"];
        self.labelTotal.text = [NSString stringWithFormat:@"Cart: %@pcs, %@$", totalAmount, totalSum];
    }
}

#pragma mark - --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - --UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.FRC.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.FRC.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSCartCell class]) forIndexPath:indexPath];
    MSCart *cart = [self.FRC objectAtIndexPath:indexPath];
    cell.name.text = cart.product.name;
    cell.price.text = [NSString stringWithFormat:@"%i$", cart.product.price];
    cell.amount.text = [NSString stringWithFormat:@"%i", cart.amount];
    return cell;
}

#pragma mark - --NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            if (![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateLabelTotal];
    [self.tableView endUpdates];
}

@end
