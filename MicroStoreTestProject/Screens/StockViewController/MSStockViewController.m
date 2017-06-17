//
//  StockViewController.m
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "MSStockViewController.h"
#import "MSStockCell.h"

@interface MSStockViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCart;

@property (nonatomic) NSFetchedResultsController *stockFRC;
@property (nonatomic) NSFetchedResultsController *cartFRC;

- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MSStockViewController

#pragma mark - --Init
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCartButton];
}

#pragma mark - --Setters&Getters
- (NSFetchedResultsController *)stockFRC
{
    if (!_stockFRC) {
        _stockFRC = [MSStock MR_fetchAllSortedBy:@"product.name"
                                       ascending:YES
                                   withPredicate:[NSPredicate predicateWithFormat:@"amount > 0"]
                                         groupBy:nil
                                        delegate:self];
    }
    return _stockFRC;
}

- (NSFetchedResultsController *)cartFRC
{
    if (!_cartFRC) {
        _cartFRC = [MSCart MR_fetchAllSortedBy:@"product.name"
                                     ascending:YES
                                 withPredicate:nil
                                       groupBy:nil
                                      delegate:self];
    }
    return _cartFRC;
}

#pragma mark - --Buttons
- (IBAction)buyAction:(UIButton *)sender
             forEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        MSStock *stock = [self.stockFRC objectAtIndexPath:indexPath];
        MSCart *cart = [MSCart MR_findFirstByAttribute:@"product" withValue:stock.product];
        if (!cart) {
            cart = [MSCart MR_createEntity];
            cart.product = stock.product;
            cart.amount = 1;
        } else {
            cart.amount ++;
        }
        stock.amount --;
    }
}

#pragma mark - --Logic
- (void)updateCartButton
{
    NSArray *shoppingCart = self.cartFRC.fetchedObjects;
    if (shoppingCart.count == 0) {
        [self.buttonCart setTitle:@"Cart empty" forState:UIControlStateNormal];
        self.buttonCart.enabled = NO;
    } else {
        NSNumber *totalSum = [shoppingCart valueForKeyPath: @"@sum.cost"];
        NSNumber *totalAmount = [shoppingCart valueForKeyPath: @"@sum.amount"];
        
        NSString *title = [NSString stringWithFormat:@"Cart: %@pcs, %@$", totalAmount, totalSum];
        [self.buttonCart setTitle:title forState:UIControlStateNormal];
        self.buttonCart.enabled = YES;
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
    return self.stockFRC.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.stockFRC.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSStockCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSStockCell class]) forIndexPath:indexPath];
    MSStock *stock = [self.stockFRC objectAtIndexPath:indexPath];
    cell.name.text = stock.product.name;
    cell.price.text = [NSString stringWithFormat:@"%i$", stock.product.price];
    cell.amount.text = [NSString stringWithFormat:@"%i", stock.amount];
    return cell;
}

#pragma mark - --NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:self.stockFRC]) {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([controller isEqual:self.stockFRC]) {
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
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:self.stockFRC]) {
        [self.tableView endUpdates];
    }
    if ([controller isEqual:self.cartFRC]) {
        [self updateCartButton];
    }
}


@end
