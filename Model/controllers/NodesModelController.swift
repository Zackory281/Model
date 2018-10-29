//
//  ModelController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodesModelController {
	
	private let _nodesModel:NodesModel
	private weak var _guiDelegate:GUIDelegate?
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
	}
	
	func clickToggleNode(_ x: Int, _ y: Int) -> Void {
		print("Toggled \(x), \(y)")
		_guiDelegate?.addPathNode(x, y)
	}
}

protocol GUIDelegate: NSObjectProtocol {
	
	func addPathNode(_ x: Int, _ y:Int)
}
