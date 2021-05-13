//
//  ViewController.swift
//  Games
//
//  Created by period6 on 4/5/21.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var brick1: UIView!
    @IBOutlet weak var brick2: UIView!
    @IBOutlet weak var brick3: UIView!
    @IBOutlet weak var brick4: UIView!
    @IBOutlet weak var brick5: UIView!
    
    @IBOutlet weak var brickBreakerBall: UIView!
    @IBOutlet weak var brickBreakerPaddle: UIView!
  
    @IBOutlet weak var restartButton: UIButton!
   
    var dynamicAnimator: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    var collisionBehavior: UICollisionBehavior!
    var ballDynamicBehavior: UIDynamicItemBehavior!
    var paddleDynamicBehavior: UIDynamicItemBehavior!
    var bricksDynamicBehovior: UIDynamicItemBehavior!
    
    var bricks = [UIView]()
    var brickCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brickBreakerBall.layer.masksToBounds = true
        brickBreakerBall.layer.cornerRadius = 10
        brickBreakerBall.isHidden = true
        brickBreakerPaddle.isHidden = true
        bricks = [brick1, brick2, brick3, brick4, brick5]
    
        
    }

    @IBAction func movePaddle(_ sender: UIPanGestureRecognizer) {
        brickBreakerPaddle.center = CGPoint(x: sender.location(in: view).x, y: brickBreakerPaddle.center.y)
        dynamicAnimator.updateItem(usingCurrentState: brickBreakerPaddle)
    }
    func dynamicBehaviors() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        pushBehavior = UIPushBehavior(items: [brickBreakerBall], mode: .instantaneous)
        pushBehavior.active = true
        pushBehavior.pushDirection = CGVector(dx: 0.2, dy: 0.1)
        pushBehavior.magnitude = 0.13
        dynamicAnimator.addBehavior(pushBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [brickBreakerPaddle, brickBreakerBall] + bricks)
        collisionBehavior.collisionMode = .everything
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        collisionBehavior.collisionDelegate = self
        
        ballDynamicBehavior = UIDynamicItemBehavior(items: [brickBreakerBall])
        ballDynamicBehavior.allowsRotation = false
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.friction = 0.0
        ballDynamicBehavior.resistance = 0.0
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        paddleDynamicBehavior = UIDynamicItemBehavior(items: [brickBreakerPaddle])
        paddleDynamicBehavior.density = 1000.0
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        bricksDynamicBehovior = UIDynamicItemBehavior(items: bricks)
        bricksDynamicBehovior.density = 1000.0
        bricksDynamicBehovior.allowsRotation = false
        dynamicAnimator.addBehavior(bricksDynamicBehovior)
    
    }
 
    @IBAction func startButton(_ sender: UIButton) {
        dynamicBehaviors()
        brickBreakerPaddle.isHidden = false
        brickBreakerBall.isHidden = false
        sender.isHidden = true
        
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        for wes in bricks {
            if item1.isEqual(brickBreakerBall) && item2.isEqual(wes) {
                wes.isHidden = true
                collisionBehavior.removeItem(wes)
                brickCount -= 1
                
            }
            if brickCount == 0 {
                self.brickBreakerBall.isHidden = true
                self.brickBreakerPaddle.isHidden = true
                collisionBehavior.removeItem(brickBreakerBall)
                alert2()
            }
        }
        
        
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if p.y > brickBreakerPaddle.center.y + 20 {
            alert()
        }
    }
    
    func alert() {
        let losingAlert = UIAlertController(title: "YOU LOST", message: "NICE TRY", preferredStyle: .alert)
        let newGameButton = UIAlertAction(title: "New Game?", style: .default) {_ in
            
        
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        losingAlert.addAction(newGameButton)
        losingAlert.addAction(cancelButton)
        
        present(losingAlert, animated: true, completion: nil)
    }
    
    func alert2() {
        let winningAlert = UIAlertController(title: "YOU WON!!", message: "GOOD JOB", preferredStyle: .alert)
        let newGameButton = UIAlertAction(title: "NEW GAME?", style: .default) {(action) in
            self.brickCount = 5
            self.restartButton.isHidden = false
            
            
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        winningAlert.addAction(newGameButton)
        winningAlert.addAction(cancelButton)
        
        present(winningAlert, animated: true, completion: nil)
    }
}
