//
//  SecondViewController.swift
//  iOS-client
//
//  Created by Kamiel Klumpers on 09/02/2017.
//  Copyright © 2017 arnaudschloune. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, AsyncClientDelegate, UIGestureRecognizerDelegate {
    let selectionHandler = SelectionHandler.sharedInstance
    
    var client : AsyncClient? = nil
    var colors = [String : UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = selectionHandler.iClient
        colors = ColorHelper.colors
        
        // swipes
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SecondViewController.swiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SecondViewController.swiped(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    /**
     * Source:
     * http://stackoverflow.com/questions/30875072/swift-ios-changing-view-using-swipe-gesture
     * http://stackoverflow.com/questions/33349101/ios-app-crashing-durring-swipe-gesture
     */
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                selectionHandler.next()
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                selectionHandler.prev()
                break
                
            default:
                return
            }
            updateSelection()
            client?.sendObject(selectionHandler.getSelectedColor() as NSCoding)
        }
    }
    
    // update View
    func updateSelection(){
        self.view.backgroundColor = colors[selectionHandler.getSelectedColor()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = colors[selectionHandler.getSelectedColor()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        client?.sendObject(sender.titleLabel?.text as NSCoding!)
    }
}
