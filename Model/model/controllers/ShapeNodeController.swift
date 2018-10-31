//
//  NodeManager.swift
//  Model
//
//  Created by Zackory Cramer on 10/25/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeNodeController {
	
	private var _shapeNodes :Set<ShapeNode>
	private var _shapeHeadNodes :Set<ShapeNode>
	weak var _nodeActionDelegate:ShapeNodeActionDelegate?
	
	init() {
		_shapeNodes = Set<ShapeNode>()
		_shapeHeadNodes = Set<ShapeNode>()
	}
	
	func addHeadNode(head :ShapeNode) {
		_shapeHeadNodes.insert(head)
	}
	
	func tick() {
		for head in _shapeHeadNodes {
			let _ = head.advance()
		}
	}
}
