//
//  UpgradesViewController.swift
//  LhamaGame
//
//  Created by Ricardo Hochman on 16/04/15.
//  Copyright (c) 2015 Ricardo Hochman. All rights reserved.
//

import UIKit

class UpgradesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let defaults = NSUserDefaults.standardUserDefaults()
    var produtos:NSArray = ["Multiplicador - x\(UpgradesSingleton.sharedInstance.multiplierClick)", "Timer - +\(UpgradesSingleton.sharedInstance.multiplierTimer) LPS", "Timer Plus - +\(UpgradesSingleton.sharedInstance.multiplierTimerPlus) LPS"]
    var precos:[NSNumber] = [UpgradesSingleton.sharedInstance.costMultiClick,UpgradesSingleton.sharedInstance.costMultiTimer,UpgradesSingleton.sharedInstance.costMultiTimerPlus]
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    // animation for when the TableViewCell appear
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier") as? UpgradesTableViewCell
        
        cell!.title.text = "\(produtos.objectAtIndex(indexPath.row))"
        
        var numberFormatter:NSNumberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale.currentLocale()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.groupingSeparator = "."
        
        var texto:NSString = (numberFormatter.stringFromNumber(precos[indexPath.row]))!

        cell!.detail.text = "\(texto)"

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UpgradesSingleton.sharedInstance.recuperarValores()
        let acao11:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementMultiplierClick()
        }
        
        let acao21:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementCostMultiplierClick()
        }
        let acao12:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementMultiplierTimer()
        }
        
        let acao22:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementCostMultiplierTimer()
        }
        let acao13:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementMultiplierTimerPlus()
        }
        
        let acao23:(()->Void) = {
            UpgradesSingleton.sharedInstance.incrementCostMultiplierTimerPlus()
        }

        
        if indexPath.row == 0 {
            self.confirmarCompra(UpgradesSingleton.sharedInstance.multiplierClick, preco: UpgradesSingleton.sharedInstance.costMultiClick, index: indexPath.row, acao1: acao11 , acao2: acao21)
            self.table.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if indexPath.row == 1 {
            self.confirmarCompra(UpgradesSingleton.sharedInstance.multiplierTimer, preco: UpgradesSingleton.sharedInstance.costMultiTimer, index: indexPath.row, acao1: acao12, acao2: acao22)
            self.table.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if indexPath.row == 2 {
            self.confirmarCompra(UpgradesSingleton.sharedInstance.multiplierTimerPlus, preco: UpgradesSingleton.sharedInstance.costMultiTimerPlus, index: indexPath.row, acao1: acao13, acao2: acao23)
            self.table.deselectRowAtIndexPath(indexPath, animated: true)
        }

    }
    
    
    func confirmarCompra(produto: Int, preco:Int, index:Int, acao1:()->Void, acao2:()->Void) {
        if UpgradesSingleton.sharedInstance.gameScore >= preco {
            var numberFormatter:NSNumberFormatter = NSNumberFormatter()
            numberFormatter.locale = NSLocale.currentLocale()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.groupingSeparator = "."
            
            var texto:NSString = (numberFormatter.stringFromNumber(preco))!

            let alerta: UIAlertController = UIAlertController(title: "Custo \(texto)", message: "Deseja realmente comprar?", preferredStyle:.Alert)
            let alerta3: UIAlertAction = UIAlertAction(title: "NÃO", style: .Default, handler: { (ACTION) -> Void in
                
            })
            let alerta1: UIAlertAction = UIAlertAction(title: "SIM", style: .Default) { (ACTION) -> Void in
                // ação quando o botao é apertado
                UpgradesSingleton.sharedInstance.gameScore -= preco
                self.defaults.setObject(UpgradesSingleton.sharedInstance.gameScore, forKey: "gameScore")
                UpgradesSingleton.sharedInstance.recuperarValores()
                acao1()
                acao2()

                self.produtos = ["Multiplicador - x\(UpgradesSingleton.sharedInstance.multiplierClick)", "Timer - +\(UpgradesSingleton.sharedInstance.multiplierTimer) LPS", "Timer Plus - +\(UpgradesSingleton.sharedInstance.multiplierTimerPlus) LPS"]
                self.precos = [UpgradesSingleton.sharedInstance.costMultiClick,UpgradesSingleton.sharedInstance.costMultiTimer,UpgradesSingleton.sharedInstance.costMultiTimerPlus]

                
                self.table.reloadData()
            }
            // adiciona a ação no alertController
            [alerta.addAction(alerta3)]
            [alerta.addAction(alerta1)]
            
            // adiciona o alertController na view
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            
            var numberFormatter:NSNumberFormatter = NSNumberFormatter()
            numberFormatter.locale = NSLocale.currentLocale()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.groupingSeparator = "."
            
            var texto:NSString = (numberFormatter.stringFromNumber (preco - UpgradesSingleton.sharedInstance.gameScore))!
            
            let alerta: UIAlertController = UIAlertController(title: "Você não possui lhamas suficientes", message: "Jogue mais para conseguir! Faltam \(texto)", preferredStyle:.Alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) -> Void in
            }
            
            // adiciona a ação no alertController
            [alerta.addAction(action)]
            
            // adiciona o alertController na view
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        let alerta: UIAlertController = UIAlertController(title: "Deseja apagar todo o historico?", message: nil, preferredStyle:.ActionSheet)
        let alerta3: UIAlertAction = UIAlertAction(title: "NÃO", style: .Default, handler: { (ACTION) -> Void in
        })
        let alerta1: UIAlertAction = UIAlertAction(title: "SIM", style: .Destructive) { (ACTION) -> Void in
            let alerta: UIAlertController = UIAlertController(title: "Tem certeza?", message: "Não podera ser revertido", preferredStyle:.Alert)
            let alerta3: UIAlertAction = UIAlertAction(title: "NÃO", style: .Default, handler: { (ACTION) -> Void in
            })
            let alerta1: UIAlertAction = UIAlertAction(title: "SIM", style: .Destructive) { (ACTION) -> Void in
                UpgradesSingleton.sharedInstance.gameScore = 0
                UpgradesSingleton.sharedInstance.multiplierClick = 1
                UpgradesSingleton.sharedInstance.costMultiClick = 100
                UpgradesSingleton.sharedInstance.multiplierTimer = 0
                UpgradesSingleton.sharedInstance.costMultiTimer = 200
                UpgradesSingleton.sharedInstance.multiplierTimerPlus = 0
                UpgradesSingleton.sharedInstance.costMultiTimerPlus = 30000

                
                self.defaults.setObject(UpgradesSingleton.sharedInstance.gameScore, forKey: "gameScore")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.multiplierClick, forKey: "multiplierClick")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.costMultiClick, forKey: "costMultiClick")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.multiplierTimer, forKey: "multiplierTimer")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.costMultiTimer, forKey: "costMultiTimer")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.multiplierTimerPlus, forKey: "multiplierTimerPlus")
                self.defaults.setObject(UpgradesSingleton.sharedInstance.costMultiTimerPlus, forKey: "costMultiTimerPlus")


                UpgradesSingleton.sharedInstance.recuperarValores()

                
                self.produtos = ["Multiplicador - x\(UpgradesSingleton.sharedInstance.multiplierClick)", "Timer - x\(UpgradesSingleton.sharedInstance.multiplierTimer)", "Timer Plus - x\(UpgradesSingleton.sharedInstance.multiplierTimerPlus)"]
                self.precos = [UpgradesSingleton.sharedInstance.costMultiClick,UpgradesSingleton.sharedInstance.costMultiTimer,UpgradesSingleton.sharedInstance.costMultiTimerPlus]
                
                self.table.reloadData()

            }
            
            [alerta.addAction(alerta3)]
            [alerta.addAction(alerta1)]
            self.presentViewController(alerta, animated: true, completion: nil)
            
        }
        [alerta.addAction(alerta3)]
        [alerta.addAction(alerta1)]
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
}


