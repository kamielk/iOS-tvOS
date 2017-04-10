//
//  ViewController.swift
//  iOS-client
//
//  Created by Arnaud Schloune on 13/10/15.
//  Copyright © 2015 arnaudschloune. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, AsyncClientDelegate {
    
    let selectionHandler = SelectionHandler.sharedInstance
    var iClient : AsyncClient? = nil
    
    var timer : Timer? = nil
    var connected = false
    
    var buttons = [ColorButton]()
    
    func buttonAction(_ sender: ColorButton!){
        print(sender.color + " pressed")
        updateSelection(sender.color)
    }
    
    func updateSelection(_ color : String){
        if(color == "green"){
            selectionHandler.selectedIndex = 0
        } else if(color == "blue"){
            selectionHandler.selectedIndex = 1
        } else if(color == "red"){
            selectionHandler.selectedIndex = 2
        } else if(color == "yellow"){
            selectionHandler.selectedIndex = 3
        }
        
        // Clear the titles
        for button in buttons {
            button.setTitle("", for: .normal)
        }
        
        let selected = buttons[selectionHandler.selectedIndex]
        selected.setTitle("selected", for: .normal)
        selected.setTitleColor(UIColor.black, for: .normal)
        
        // send message to the server
        iClient?.sendObject(selected.color as NSCoding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(FirstViewController.connect), userInfo: nil, repeats: true)
        
        self.iClient = selectionHandler.iClient
        self.iClient?.autoConnect = true
        
        let screen: CGRect = UIScreen.main.bounds
        let width = screen.width;
        let height = screen.height;
        
        let greenButton = ColorButton(frame: CGRect(x: 0, y: 0, width: (width/2), height: (height/2)))
        greenButton.color = "green";
        greenButton.backgroundColor = ColorHelper.colors["green"]
        greenButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let blueButton = ColorButton(frame: CGRect(x: (width/2), y: 0, width: (width/2), height: (height/2)))
        blueButton.color = "blue";
        blueButton.backgroundColor = ColorHelper.colors["blue"]
        blueButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let redButton = ColorButton(frame: CGRect(x: 0, y: (height/2), width: (width/2), height: (height/2)))
        redButton.color = "red";
        redButton.backgroundColor = ColorHelper.colors["red"]
        redButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let yellowButton = ColorButton(frame: CGRect(x: (width/2), y: (height/2), width: (width/2), height: (height/2)))
        yellowButton.color = "yellow"
        yellowButton.backgroundColor = ColorHelper.colors["yellow"]
        yellowButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        buttons.append(greenButton)
        buttons.append(blueButton)
        buttons.append(redButton)
        buttons.append(yellowButton)
        
        for button in buttons {
            self.view.addSubview(button)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(iClient != nil){
            iClient?.serviceType = "_ClientServer._tcp"
            iClient?.delegate = self
            iClient?.start()
        } else {
            print("FIRSTVC - client is nil")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapButton(_ sender: UIButton) {
        iClient?.sendObject(sender.titleLabel?.text as NSCoding!)
    }
    
    func connect(){
        print("Trying to connect...")
        let service = NetService(domain: "local.", type: "_ClientServer._tcp", name: "tvOS")
        iClient?.connect(to: service)
    }
    
    func client(_ theClient: AsyncClient!, didFind service: NetService!, moreComing: Bool) -> Bool {
        print("didFindService")
        print(service)
        return true
    }
    
    func client(_ theClient: AsyncClient!, didRemove service: NetService!) {
        
        print("didRemoveService")
        print(theClient)
    }
    
    func client(_ theClient: AsyncClient!, didConnect connection: AsyncConnection!) {
        print("didConnect")
        self.timer?.invalidate()
        self.timer = nil
        print(theClient)
    }
    
    func client(_ theClient: AsyncClient!, didDisconnect connection: AsyncConnection!) {
        print("diddisconnect")
        self.connected = false;
        print(theClient)
    }
    
    func client(_ theClient: AsyncClient!, didReceiveCommand command: AsyncCommand, object: Any!, connection: AsyncConnection!) {
        print("didreceivecommand")
        print(object as! String)
        updateSelection(object as! String)
        
        (self.tabBarController?.viewControllers?[1] as! SecondViewController).updateSelection()
    }
    
    func client(_ theClient: AsyncClient!, didFailWithError error: Error!) {
        print("didfailwitherror")
    }
}

