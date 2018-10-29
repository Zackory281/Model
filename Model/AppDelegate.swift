//
//  AppDelegate.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var nodesModelController:NodesModelController!
	
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		let controller = NSApplication.shared.mainWindow!.contentViewController as! NodesFieldViewController
		let scene = NodeScene.init(size: CGSize(width: 800, height: 600))
		let model = NodesModel()
		let sceneController = SceneController(scene: scene)
		let nodesModelController = NodesModelController(nodesModel: model, guiDelegate: sceneController)
		
		sceneController._nodesModelController = nodesModelController
		scene.inputDelegate = sceneController
		
		controller._modelController = nodesModelController
		controller.putOnScene(scene: scene)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
