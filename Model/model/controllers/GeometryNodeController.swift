//
//  GeometryNodeController.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class GeometryNodeController {
	
	var _nodeTree = NodeTree<GeometryNode>(width: 100, height: 100)
	private weak var _queue: GUIQueue?
	
	func add(geometry: GeometryNode) -> Bool {
		for point in geometry._pointsOccupied {
			guard _nodeTree.getNodesAt(point.0, point.1).isEmpty else {
				return false
			}
		}
		for point in geometry._pointsOccupied {
			_nodeTree.add(node: geometry, at: point)
		}
		_queue?.add(node: geometry)
		return true
	}
	
	init(queue: GUIQueue) {
		_queue = queue
	}
}
