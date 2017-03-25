//
//  TradeFormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/27/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

enum SectionNames: String {
    case Input = "INPUT"
    case Settings = "SETTINGS"
    case Returns = "RETURNS"
    case Costs = "COSTS"
    case LiveTrade = "Live Trade"
}

enum FormFieldNames: String {
    case Strategy = "Select a Strategy"
    case Broker = "Select a Broker"
    case ExpectedReturn = "Expected Return"
    case ROC = "Return on Capital (%)"
    case Premium = "Premium"
    case MaxLoss = "Max Loss"
    case POP = "POP"
    case Contracts = "Contracts"
    case Commissions = "Commissions"
    case DaysToExpiration = "Days To Expiration"
    case ReturnPerDay = "Return Per Day"
    case Share = "Share"
    case Ticker = "Ticker"
    case MaxProfit = "Max Profit"
}

final class TradeFormController: NSObject {
    
    static let shareText = "Tap to Share"
    
    var form: Form?
    var controller: TradeTableViewController?
    var strategies = StrategyController.sharedInstance.all()
    var firstStrategy: Strategy?
    var brokers = BrokerController.sharedInstance.all()
    var firstBroker: Broker?
    
    init(form: Form, controller: TradeTableViewController) {
        self.form = form
        self.controller = controller
    }
    
    func refreshForm() {
        strategies = StrategyController.sharedInstance.all()
        firstStrategy = strategies.first
        let strategyRow: ActionSheetRow<String>?  = form?.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.options = strategies.map{$0.name}
        strategyRow?.reload()
        
        brokers = BrokerController.sharedInstance.all()
        firstBroker = brokers.first
        let brokerRow: ActionSheetRow<String>?  = form?.rowBy(tag: FormFieldNames.Broker.rawValue)
        brokerRow?.options = brokers.map{$0.name}
        brokerRow?.reload()
    }
    
    func formSetup() {
        formInputSetup(form: form!)
        formReturnsSetup(form: form!)
        formLiveTradeSetup(form: form!)
        formSettingsSetup(form: form!)
        formCostsSetup(form: form!)
    }
    
    func formInputSetup(form: Form) {
        form
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Input.rawValue)
                }()
                }
                <<< DecimalRow(FormFieldNames.Premium.rawValue){ row in
                    row.useFormatterDuringInput = true
                    row.title = FormFieldNames.Premium.rawValue
                    row.value = 0
                    row.formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller?.trade.premium = Double(rowValue)
                            self.updateOutputFields()
                        }
                }
                <<< DecimalRow(FormFieldNames.MaxLoss.rawValue){ row in
                    row.useFormatterDuringInput = true
                    row.title = FormFieldNames.MaxLoss.rawValue
                    row.value = 0
                    row.formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller?.trade.maxLoss = Double(rowValue)
                            self.updateOutputFields()
                        }
                }
                <<< IntRow(FormFieldNames.POP.rawValue) { row in
                    row.title = FormFieldNames.POP.rawValue + "(\(Int(self.controller!.currentStrategy!.maxProfitPercentage)))"
                    row.value = self.controller?.trade.pop
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller?.trade.pop = rowValue
                            self.updateOutputFields()
                        }
                }
                <<< IntRow(FormFieldNames.Contracts.rawValue) { row in
                    row.title = FormFieldNames.Contracts.rawValue
                    row.value = self.controller?.trade.contracts
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller?.trade.contracts = rowValue
                            self.updateOutputFields()
                        }
                }
                <<< IntRow(FormFieldNames.DaysToExpiration.rawValue) { row in
                    row.title = FormFieldNames.DaysToExpiration.rawValue
                    row.value = self.controller?.trade.daysToExpiration
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller?.trade.daysToExpiration = rowValue
                            self.updateOutputFields()
                        }
            }
    }
    
    func formReturnsSetup(form: Form) {
        form
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Returns.rawValue)
                }()
                }
                <<< LabelRow(FormFieldNames.MaxProfit.rawValue){ row in
                    row.title = FormFieldNames.MaxProfit.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
                }
                <<< LabelRow(FormFieldNames.ExpectedReturn.rawValue){ row in
                    row.title = FormFieldNames.ExpectedReturn.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
                }
                <<< LabelRow(FormFieldNames.ROC.rawValue){ row in
                    row.title = FormFieldNames.ROC.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
                }
                <<< LabelRow(FormFieldNames.ReturnPerDay.rawValue){ row in
                    row.title = FormFieldNames.ReturnPerDay.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        }
    }
    
    func formLiveTradeSetup(form: Form) {
        form
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.LiveTrade.rawValue)
                }()
            }
            <<< TextRow(FormFieldNames.Ticker.rawValue){ row in
                row.title = FormFieldNames.Ticker.rawValue
                row.value = self.controller?.trade.ticker
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.ticker = rowValue
                        self.updateOutputFields()
                        Defaults[.ticker] = rowValue
                    }
            }
            <<< LabelRow(FormFieldNames.Share.rawValue){ row in
                row.title = FormFieldNames.Share.rawValue
                row.value = TradeFormController.shareText
                }.onCellSelection { cell, row in
                    let tickerRow: TextRow? = self.form?.rowBy(tag: FormFieldNames.Ticker.rawValue)
                    if let row = tickerRow {
                        let rowIsEmpty = FormController.sharedInstance.rowIsEmpty(row: row)
                        if rowIsEmpty {
                            FormController.sharedInstance.alertTextRowIsEmpty(name: FormFieldNames.Ticker.rawValue, controller: self.controller)
                        } else {
                            if let controller = self.controller {
                                FormController.sharedInstance.share(trade: controller.trade, controller: controller)
                            }
                        }
                    }
        }
    }
    
    func formSettingsSetup(form: Form) {
        form
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Settings.rawValue)
                }()
            }
            <<< ActionSheetRow<String>(FormFieldNames.Strategy.rawValue) { row in
                row.title = FormFieldNames.Strategy.rawValue
                row.selectorTitle = FormFieldNames.Strategy.rawValue
                row.options = strategies.map{$0.name}
                row.value = firstStrategy?.name
                }.onChange { row in
                    if let rowValue = row.value, let strategy = StrategyController.sharedInstance.find(name: rowValue).first {
                        self.controller?.currentStrategy = strategy
                        self.controller?.trade.commissions = self.controller!.trade.totalCommissions(commission: self.controller!.currentBroker!.commission, legs: self.controller!.currentStrategy!.legs)
                        let popRow: IntRow? = self.form!.rowBy(tag: FormFieldNames.POP.rawValue)
                        popRow!.title = FormFieldNames.POP.rawValue + "(\(Int(self.controller!.currentStrategy!.maxProfitPercentage)))"
                        self.updateOutputFields()
                        Defaults[.strategy] = strategy.strategyId
                    }
            }
            <<< ActionSheetRow<String>(FormFieldNames.Broker.rawValue) { row in
                row.title = FormFieldNames.Broker.rawValue
                row.selectorTitle = FormFieldNames.Broker.rawValue
                row.options = brokers.map{$0.name}
                row.value = firstBroker?.name
                }.onChange { row in
                    if let rowValue = row.value, let broker = BrokerController.sharedInstance.find(name: rowValue).first {
                        self.controller?.currentBroker = broker
                        self.controller?.trade.commissions = self.controller!.trade.totalCommissions(commission: self.controller!.currentBroker!.commission, legs: self.controller!.currentStrategy!.legs)
                        self.updateOutputFields()
                        Defaults[.broker] = broker.brokerId
                    }
        }
    }
    
    func formCostsSetup(form: Form) {
        form
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Costs.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.Commissions.rawValue){ row in
                row.title = FormFieldNames.Commissions.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        }
    }
    
    func updateOutputFields() {
        let calculatedFieldValueHash = TradeFormFieldController.sharedInstance.calculatedHash(trade: self.controller!.trade, strategy: self.controller!.currentStrategy!, broker: self.controller!.currentBroker!)
        TradeFormFieldController.sharedInstance.updateOutputFields(form: self.controller!.form, trade: self.controller!.trade, calculatedFieldValueHash: calculatedFieldValueHash)
    }
}
