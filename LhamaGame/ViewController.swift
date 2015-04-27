//
//  ViewController.swift
//  LhamaGame
//
//  Created by Ricardo Hochman on 16/04/15.
//  Copyright (c) 2015 Ricardo Hochman. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    var audio:AVAudioPlayer!
    var clicks:Int?
    @IBOutlet weak var lblsegundos: UILabel!
    @IBOutlet weak var imgLhama: UIImageView!
    @IBOutlet weak var lblPontuacao: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)

        clicks = 0
        lblsegundos.text = "\((clicks)!*(UpgradesSingleton.sharedInstance.multiplierClick) + (UpgradesSingleton.sharedInstance.multiplierTimer + UpgradesSingleton.sharedInstance.multiplierTimerPlus)) LPS (Lhamas per second)"
        imgLhama.center.x = view.frame.size.width / 2
        imgLhama.center.y = view.frame.size.height / 2
        
        // user default para recuperar a pontuação
        UpgradesSingleton.sharedInstance.recuperarValores()
        // exibe a pontuação
        imgLhama.tag = 1

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // correção de um erro que causava as vezes
        if UpgradesSingleton.sharedInstance.multiplierClick == 0 {
            UpgradesSingleton.sharedInstance.multiplierClick = 1
            UpgradesSingleton.sharedInstance.costMultiClick = 100
            UpgradesSingleton.sharedInstance.multiplierTimer = 0
            UpgradesSingleton.sharedInstance.costMultiTimer = 200
            UpgradesSingleton.sharedInstance.multiplierTimerPlus = 0
            UpgradesSingleton.sharedInstance.costMultiTimerPlus = 300000

            defaults.setObject(UpgradesSingleton.sharedInstance.multiplierClick, forKey: "multiplierClick")
            defaults.setObject(UpgradesSingleton.sharedInstance.costMultiClick, forKey: "costMultiClick")
            defaults.setObject(UpgradesSingleton.sharedInstance.multiplierTimer, forKey: "multiplierTimer")
            defaults.setObject(UpgradesSingleton.sharedInstance.costMultiTimer, forKey: "costMultiTimer")
            defaults.setObject(UpgradesSingleton.sharedInstance.multiplierTimerPlus, forKey: "multiplierTimerPlus")
            defaults.setObject(UpgradesSingleton.sharedInstance.costMultiTimerPlus, forKey: "costMultiTimerPlus")

        }
        self.atualizar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = (touches as NSSet).allObjects[0] as! UITouch
        let touchLocation = touch.locationInView(self.view)
        
        for obstacleView in self.view.subviews {
            let obstacleViewFrame = self.view.convertRect(obstacleView.frame, toView: obstacleView.superview)
            if (CGRectContainsPoint(obstacleViewFrame, touchLocation)) {
                if obstacleView.tag == 1 {
                    self.imgLhama.frame.size = CGSizeApplyAffineTransform(self.imgLhama.frame.size, CGAffineTransformMakeScale(0.95,0.95))
                    imgLhama.center.x = view.frame.size.width / 2
                    imgLhama.center.y = view.frame.size.height / 2
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = (touches as NSSet).allObjects[0] as! UITouch
        let touchLocation = touch.locationInView(self.view)
        
        for obstacleView in self.view.subviews {
            let obstacleViewFrame = self.view.convertRect(obstacleView.frame, toView: obstacleView.superview)
            if (CGRectContainsPoint(obstacleViewFrame, touchLocation)) {
                if obstacleView.tag == 1 {
                    self.imgLhama.frame.size = CGSizeApplyAffineTransform(self.imgLhama.frame.size, CGAffineTransformMakeScale(1.05,1.05))
                    UpgradesSingleton.sharedInstance.incrementGameScore()
                    self.atualizar()
                    
                    let randomX = randomInRange(Int(CGFloat(self.imgLhama.frame.origin.x)), hi: Int(CGFloat(self.imgLhama.center.x + self.imgLhama.frame.width / 2 - 20)))
                    let randomY = randomInRange(Int(CGFloat(self.imgLhama.frame.origin.y)), hi: Int(CGFloat(self.imgLhama.center.y + self.imgLhama.frame.height / 2 - 20)))
                    let flX:CGFloat = CGFloat(randomX)
                    let flY:CGFloat = CGFloat(randomY)
                    
                    var lblMais = UILabel(frame: CGRectMake(0, 0, 100, 100))
                    lblMais.text = "+\(UpgradesSingleton.sharedInstance.multiplierClick)"
                    lblMais.font = UIFont(name: "Chalkduster", size: 25)
                    lblMais.transform = CGAffineTransformMakeTranslation(flX, flY)
                    self.view.addSubview(lblMais)
                    clicks = clicks! + 1
                    
                    // toca o som da lhama
                    var bundle:NSBundle = NSBundle.mainBundle()
                    var str:NSString = bundle.pathForResource("lhama", ofType: "mp3")!
                    var data:NSData = NSData(contentsOfFile: str as String)!
                    audio = AVAudioPlayer(data: data, error: nil)
                    audio.delegate = self
                    audio.volume = 1.0

                    self.audio.play()

                    UIView.transitionWithView(self.view, duration: 1, options: nil, animations: {
                        lblMais.center.y -= 30
                        lblMais.alpha = 0.4
                        }, completion: { finished in
                            lblMais.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    func atualizar() {
        var numberFormatter:NSNumberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale.currentLocale()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.groupingSeparator = "."
        
        var texto:NSString = (numberFormatter.stringFromNumber (UpgradesSingleton.sharedInstance.gameScore))!
        lblPontuacao.text = "\(texto) LHAMAS"
        println("pontos: \(UpgradesSingleton.sharedInstance.gameScore)")
        println("multi click: \(UpgradesSingleton.sharedInstance.multiplierClick)")
        println("multi timer: \(UpgradesSingleton.sharedInstance.multiplierTimer + UpgradesSingleton.sharedInstance.multiplierTimerPlus)")
    }

    /**
    gera numeros aleatorios
    
    :param: lo - menor numero
    :param: hi - maior numero
    
    :returns: numero aleatorio
    */
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    @IBAction func segControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            imgLhama.image = UIImage(named: "lhama1")
        case 1:
            imgLhama.image = UIImage(named: "lhama-batman")
        case 2:
            imgLhama.image = UIImage(named: "lhama-ferro")
        case 3:
            imgLhama.image = UIImage(named: "lhama-ninja")
        default:
            break
        }
    }
    
    func updateCounter() {
        UpgradesSingleton.sharedInstance.gameScore = UpgradesSingleton.sharedInstance.gameScore + UpgradesSingleton.sharedInstance.multiplierTimer + UpgradesSingleton.sharedInstance.multiplierTimerPlus
        defaults.setObject(UpgradesSingleton.sharedInstance.gameScore, forKey: "gameScore")
        UpgradesSingleton.sharedInstance.gameScore = defaults.integerForKey("gameScore")
        self.atualizar()
        lblsegundos.text = "\((clicks)!*(UpgradesSingleton.sharedInstance.multiplierClick) + (UpgradesSingleton.sharedInstance.multiplierTimer + UpgradesSingleton.sharedInstance.multiplierTimerPlus)) LPS (Lhamas per second)"
        clicks = 0
    }
}

