//
//  ModelController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodesModelController :NSObject, NodesModelActionDelegate{
	
	private let _nodesModel:NodesModel
	private weak var _guiDelegate:GUIDelegate?
	
	// Mark: NodesModelActionDelegate stubs
	func uiAddPathNodes(_ nodes: [Node]) {
		guard let _guiDelegate = _guiDelegate else { return }
		for node in nodes {
			let p = node.getPoint()
			_guiDelegate.addPathNode((node as! NSObject).hash, Int(p[0]), Int(p[1]), orientation: node.getOrientations())
		}
	}
	
	func clickToggleNode(_ x: Int, _ y: Int) -> Void {
		_nodesModel.addPathNodeAt(Int16(x), Int16(y))
	}
	
	func tick() {
		let success = _nodesModel.tick()
		_guiDelegate?.dislayTickNumber(Int(_nodesModel.getTick()), success)
	}
	
	func preloadModel() {
		_nodesModel.loadModel()
	}
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
		super.init()
		_nodesModel._modelActionDelegate = self
	}
}

protocol GUIDelegate: NSObjectProtocol {
	
	func addPathNode(_ hash:Int, _ x: Int, _ y:Int, orientation: [Direction])
	func dislayTickNumber(_ tick: Int, _ success: Bool)
}
