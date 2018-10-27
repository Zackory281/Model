//
//  NodeManager.swift
//  Model
//
//  Created by Zackory Cramer on 10/25/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodeTree<T:NSObject> {
	
	private var pathNodeTree:GKQuadtree<T>
	
	init() {
		pathNodeTree = GKQuadtree<T>()
	}
	
	func addPathNode(pathNode:T) {
		let c = pathNode.getPoint()
		pathNodeTree.add(pathNode, at: float2(Float(c[0]), Float(c[1])))
	}
	
	func getNodesIn(_ cx:Int16, _ cy:Int16, _ cw:Int16, _ ch:Int16) -> [T] {
		return pathNodeTree.elements(in: GKQuad(quadMin: float2(Float(cx - cw/2), Float(cy - ch / 2)), quadMax: float2(Float(cx + cw / 2), Float(cy + ch / 2))))
	}
	
	func getNodesAt(_ x:Int16, _ y:Int16) -> [T] {
		return pathNodeTree.elements(at: float2(Float(x), Float(y)))
	}
}
