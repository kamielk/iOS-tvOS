//
//  FirstViewController.swift
//  tvOS-Server
//
//  Created by Arnaud Schloune on 13/10/15.
//  Copyright © 2015 arnaudschloune. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, AsyncServerDelegate {
    
    @IBOutlet weak var labelHello: UILabel!
    
    let server = AsyncServer()
    
    let colors = [
        "green": UIColor(netHex:0x8CFF45),
        "blue": UIColor(netHex:0x5F58E8),
        "red": UIColor(netHex:0xFF0000),
        "yellow": UIColor(netHex:0xE8E226)]
    
    let colorStrings = ["green","blue","red","yellow"]
    var selectedIndex = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        server.serviceType = "_ClientServer._tcp"
        server.serviceName = "tvOS"
        server.delegate = self
        server.start()
        
        print(server.serviceDomain)
        
        // swipes
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.swiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.swiped(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        // tap
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.tapped(gesture:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    func nextColor(){
        if(selectedIndex<3){
            selectedIndex+=1
        } else {
            selectedIndex = 0
        }
        self.view.backgroundColor = colors[colorStrings[selectedIndex]]
    }
    
    func server(_ theServer: AsyncServer!, didConnect connection: AsyncConnection!) {
        print("didconnect")
        print(connection)
    }
    
    func server(_ theServer: AsyncServer!, didReceiveCommand command: AsyncCommand, object: Any!, connection: AsyncConnection!) {
        print("didreceivecommand")
        print(command)
        
        let colorString = object as? String
        // labelHello.text = colorString
        
        var c : UIColor
        
        if(colorString == "green"){
            c = colors["green"]!
        } else if(colorString == "blue"){
            c = colors["blue"]!
        } else if(colorString == "red"){
            c = colors["red"]!
        } else if(colorString == "yellow"){
            c = self.colors["yellow"]!
        } else {
            c = UIColor.darkGray
            labelHello.text = "oepsie"
        }
        
        self.view.backgroundColor = c
    }
    
    /**
     * Source:
     * http://stackoverflow.com/questions/30875072/swift-ios-changing-view-using-swipe-gesture
     * http://stackoverflow.com/questions/33349101/ios-app-crashing-durring-swipe-gesture
     */
    public func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            print("swiped")
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                if(selectedIndex<3){
                    selectedIndex+=1
                } else {
                    selectedIndex = 0
                }
                break
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                if(selectedIndex>0){
                    selectedIndex -= 1
                } else {
                    selectedIndex = 3
                }
                break
                
            default:
                return
            }
            
            self.view.backgroundColor = colors[colorStrings[selectedIndex]]
            
            // send message to clients -> i-devices
            // ios -> tvos
            // client?.sendObject(selectionHandler.getSelectedColor() as NSCoding)
            
            server.sendObject(colorStrings[selectedIndex] as NSCoding)
        }
    }
    
    func tapped(gesture: UIGestureRecognizer){
        print("tapped")
        if(selectedIndex<3){
            selectedIndex+=1
        } else {
            selectedIndex = 0
        }
        self.view.backgroundColor = colors[colorStrings[selectedIndex]]
        server.sendObject(colorStrings[selectedIndex] as NSCoding)
    }
    
    func server(_ theServer: AsyncServer!, didDisconnect connection: AsyncConnection!) {
        print("disconnected server")
    }
    
    func server(_ theServer: AsyncServer!, didFailWithError error: Error!) {
        print("didfail")
    }
    
    //    func server(theServer: AsyncServer!, didReceiveCommand command: AsyncCommand, object: AnyObject!, connection: AsyncConnection!, responseBlock block: AsyncNetworkResponseBlock!) {
    //        print("didreceivecommand - response block")
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

