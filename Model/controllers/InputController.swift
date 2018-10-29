//
//  InputController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class InputController {
	
	var _nodesModel:NodesModel?
	
	func taped(_ x:Int, _ y:Int) {
		print("tapped!")
		_nodesModel?.addPathNodeAt(x / PATH_WIDTH, y / PATH_WIDTH)
	}
}
