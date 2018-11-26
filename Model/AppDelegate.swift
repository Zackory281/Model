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
		let setting = UISetting()
		let overlayController = UIOverlayController(scene: scene, setting: setting)
		let sceneController = SceneController(scene: scene, setting: setting, overlayController: overlayController)
		let nodesModelController = NodesModelController(nodesModel: model, guiDelegate: sceneController._guiDelegate, overlayController: overlayController)
		
		sceneController._nodesModelController = nodesModelController
		scene._inputDelegate = sceneController
		
		controller._modelController = nodesModelController
		controller.putOnScene(scene: scene)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
