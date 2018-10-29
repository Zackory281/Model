//
//  NodeTree.swift
//  Model
//
//  Created by Zackory Cramer on 10/29/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NT {
	
}

class NodesTree<T: NSObject & Node> {
	
	private var pathNodeTree:GKQuadtree<T>
	
	init() {
		pathNodeTree = GKQuadtree<T>()
	}
	
	func addPathNode(pathNode:T) {
		pathNodeTree.add(pathNode, at: pathNode.getFloatVector())
	}
	
	func getNodesIn(_ cx:Int16, _ cy:Int16, _ cw:Int16, _ ch:Int16) -> [T] {
		return pathNodeTree.elements(in: GKQuad(quadMin: float2(Float(cx - cw/2), Float(cy - ch / 2)), quadMax: float2(Float(cx + cw / 2), Float(cy + ch / 2))))
	}
	
	func getNodesAt(_ x:Int16, _ y:Int16) -> [T] {
		return pathNodeTree.elements(at: float2(Float(x), Float(y)))
	}
	
	func getNodesAt(_ x:Float, _ y:Float) -> [T] {
		return pathNodeTree.elements(at: float2(x, y))
	}
}
