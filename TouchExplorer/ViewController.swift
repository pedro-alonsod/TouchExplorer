//
//  ViewController.swift
//  TouchExplorer
//
//  Created by Pedro Alonso on 3/6/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tapsLabel: UILabel!
    @IBOutlet var touchesLabel: UILabel!
    @IBOutlet var forceLabel: UILabel!
    @IBOutlet var dragLabel: UILabel!

    private var gestureStartPoint: CGPoint!
    private static let minimumGestureLength = Float(25.0)
    private static let maximumVariance = Float(5)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateLabelsFromTouches(_ touch: UITouch?, allTouches:
        Set<UITouch>?) {
        let numTaps = touch?.tapCount ?? 0
        let tapsMessage = "\(numTaps) taps detected"
        tapsLabel.text = tapsMessage
        let numTouches = allTouches?.count ?? 0
        let touchMsg = "\(numTouches) touches detected"
        touchesLabel.text = touchMsg
        if traitCollection.forceTouchCapability == .available {
            forceLabel.text = "Force: \(touch?.force ?? 0)\nMax force: \(touch?.maximumPossibleForce ?? 0)"
        } else {
            forceLabel.text = "3D Touch not available"
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageLabel.text = "Touches Began"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches)
        
        if let touch = touches.first {
            gestureStartPoint = touch.location(in: self.view)
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event:
        UIEvent?) {
        messageLabel.text = "Touches Cancelled"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageLabel.text = "Touches Ended"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageLabel.text = "Drag Detected"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches)
        
        if let touch = touches.first, let gestureStartPoint = self.gestureStartPoint {
            let currentPosition = touch.location(in: self.view)
            let deltaX = fabsf(Float(gestureStartPoint.x - currentPosition.x))
            let deltaY = fabsf(Float(gestureStartPoint.y - currentPosition.y))
            if deltaX >= ViewController.minimumGestureLength && deltaY <= ViewController.maximumVariance {
                dragLabel.text = "Horizontal swipe detected"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                        self.dragLabel.text = ""
                }
            } else if deltaY >= ViewController.minimumGestureLength && deltaX <= ViewController.maximumVariance {
                dragLabel.text = "Vertical swipe detected"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                        self.dragLabel.text = ""
                }
            }
        }
    }
    
}

