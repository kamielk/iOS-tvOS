//
//  SelectionHandler.swift
//  iOS-client
//
//  Created by Kamiel Klumpers on 09/02/2017.
//  Copyright © 2017 arnaudschloune. All rights reserved.
//

import Foundation
//import Contentful

class SelectionHandler: NSObject {
    public var iClient = AsyncClient()
    
    static let sharedInstance = SelectionHandler()
    
    public var colors = ["green","blue","red","yellow"];
    public var selectedIndex = 0
    
    override init(){
        self.iClient = AsyncClient()
        print("SelectionHandler init")
    }
    
    public func selectColor(c : String){
        var counter = 0
        for color in colors {
            if(color == c){
                break
            }
            counter += 1
        }
        selectedIndex = counter
    }
    
    public func next(){
        if(selectedIndex<3){
            selectedIndex += 1
        } else {
            selectedIndex = 0
        }
    }
    
    public func prev(){
        if(selectedIndex>0){
            selectedIndex -= 1
        } else {
            selectedIndex = 3
        }
    }
    
    public func getSelectedColor() -> String{
        return colors[selectedIndex]
    }
    
}
