//
//  ViewController.swift
//  Canvas
//
//  Created by Rohan Trivedi on 3/22/17.
//  Copyright © 2017 Rohan Trivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var originalFaceCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayDownOffset = 200
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began
        {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed
        {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended
        {
            
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
        }
        
    }
    @IBAction func onFacePress(_ sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        
        if sender.state == .began {

            
            let imageView = sender.view as! UIImageView
            
            
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            
            newlyCreatedFace.isUserInteractionEnabled = true

            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
            newlyCreatedFace.addGestureRecognizer(panGesture)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(doubleTap)
            
            
            view.addSubview(newlyCreatedFace)
            
            newlyCreatedFace.center = imageView.center
            
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            originalFaceCenter = newlyCreatedFace.center
            
        } else if sender.state == .changed {
            
            newlyCreatedFace.center = CGPoint(x: originalFaceCenter.x + translation.x, y: originalFaceCenter.y + translation.y)
            
        } else if sender.state == .ended {
            
            if (newlyCreatedFace.frame.origin.y > trayView.frame.origin.y) {
                UIView.animate(withDuration: 2, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 0, y: 0)
                }, completion: { finished in
                    if finished {
                        self.newlyCreatedFace.removeFromSuperview()
                    }
                })
            }
        }
    }
    @IBAction func didDoubleTap(_ sender: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 3, animations: {
            sender.view?.transform = CGAffineTransform(scaleX: 0, y: 0)
        }, completion: { finished in
            if finished {
                sender.view?.removeFromSuperview()
            }
        })
    }
    var originalCenter = CGPoint()
    func didPan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            originalCenter = (sender.view?.center)!
            sender.view?.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            sender.view?.center = CGPoint(x: (originalCenter.x) + sender.translation(in: sender.view).x, y: (originalCenter.y) + sender.translation(in: sender.view).y)
        } else if sender.state == .ended {
            sender.view?.transform = CGAffineTransform.identity
        }
    }
}

