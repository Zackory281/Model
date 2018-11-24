//
//  GeometryNodeController.swift
//  Model
//
//  Created by Zackory Cramer on 11/13/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class GeometryNodeController {
	
	var _nodeMap: NodeMap
	private weak var _queue: GUIQueue?
	
	func add(geometry: GeometryNode) -> Bool {
		for point in geometry._pointsOccupied {
			let node = _nodeMap.getNodes(at: point)
			let n : [PathNodeAbstract] = node.filter{$0 is PathNodeAbstract}
			if let b = n.first?._taken, b {
				return false
			}
		}
		_nodeMap.add(node: geometry)
		_queue?.add(node: geometry)
		return true
	}
	
	init(nodeMap: NodeMap, queue: GUIQueue) {
		_queue = queue
		_nodeMap = nodeMap
	}
}
