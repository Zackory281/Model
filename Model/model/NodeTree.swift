//
//  NodeTree.swift
//  Model
//
//  Created by Zackory Cramer on 10/29/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class NodeTree<T: NSObject & Node> {
	
	private var pathNodeTree:GKQuadtree<T>
	
	init(width: Int16, height: Int16) {
		pathNodeTree = GKQuadtree<T>.init(boundingQuad: GKQuad(quadMin: float2(Float(0 - width / 2), Float(0 - height / 2)), quadMax: float2(Float(width / 2), Float(height / 2))), minimumCellSize: 0.7)
	}
	
	func exists(node: T) -> Bool {
		let p = node.getPoint()
		return !pathNodeTree.elements(at: float2(Float(p[0]), Float(p[1]))).isEmpty
	}
	func addNode(node:T) {
		let p = node.getPoint()
		pathNodeTree.add(node, at: float2(Float(p[0]), Float(p[1])))
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
