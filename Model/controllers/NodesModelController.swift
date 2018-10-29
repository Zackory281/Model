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
	func addPathNodeAt(_ x: Int, _ y: Int) {
		_guiDelegate?.addPathNode(x, y)
	}
	
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
		super.init()
		_nodesModel._modelActionDelegate = self
	}
	
	func clickToggleNode(_ x: Int, _ y: Int) -> Void {
		_nodesModel.addPathNodeAt(Int16(x), Int16(y))
	}
	
	func tick() {
		_nodesModel.tick()
	}
}

protocol GUIDelegate: NSObjectProtocol {
	
	func addPathNode(_ x: Int, _ y:Int)
}
