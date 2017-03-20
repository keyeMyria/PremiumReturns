//: Playground - noun: a place where people can play

import UIKit

/*

 Values for calculation:
 
 Percentage to close for max profit(premium): maxProfitPercentage
 Premium: premium
 
 Value for a loss: loss
 
 Probability of being a winner: winningProbability
 Probability of being a loser: losingProbability
 
 // Commissions
 Commission value: commissionPerContract
 Number of contracts: numberContracts
 commissions = commissionPerContract * numberContracts

 // Calculate the expected value(return)
 trade = ((maxProfitPercentage * maxProfit) * winningProbability) - (losingProbability * loss) - commissions
 
 Trade
 =======
 premium
 loss
 contracts
 daysToExpiration
 -----
 - totalCommissions(commissionPerContract: Double, legs: Int) -> Double
 - calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commissions: Double) -> Double
 - returnOnCapital(profit: Double, maxLoss: Double) -> Double
 - returnPerDay(totalReturn: Double, days: Int) -> Double
 =======
 
 Strategy
 =======
 type
 legs
 maxProfitPercentage
 winningProbability
 =======
 
 StrategyFactory
 =======
 - strategy(type)
 =======
 
 StrategyTableViewController
 =======
 + addCustomStrategy
 rowSelected - open editStrategy
 swipe to delete strategy
 =======
 
 EditCustomStrategy
 ==================
 modal
    new - form view with empty fields
    edit - form view with selected strategy values
 cancel
    dismiss
 done
    saveStrategy
 
 ==================
 
 Broker
 ======
 name
 commission
 ======
 
 TODO
 ====
 Add Max Profits to the trade view, refactor calculation
 Add commission to the trade
 Add Live tableview for trades with code to update with data base notifications
 Add section for live to display live activity with button to share
 Add code for Realm to use remote data store
 ====
 
*/




