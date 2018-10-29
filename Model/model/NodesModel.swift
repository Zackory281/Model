//
//  NodesModel.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModel : NSObject {
	
	private var _tick:Int16
	private var _pathNodeTree:NodeTree<PathNode>
	private var _pathNodeMap:NodeMap
	
	override init() {
		_tick = 0
		_pathNodeTree = NodeTree<PathNode>()
		super.init()
	}
	
	func addPathNodeAt(_ x:Int, _ y:Int) {
		let pathNode = PathNode(Int16(x), Int16(y))
		_pathNodeTree.addPathNode(pathNode: pathNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
