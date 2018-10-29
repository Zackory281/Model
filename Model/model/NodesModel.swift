//
//  NodesModel.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModel : NSObject, ShapeNodeActionDelegate, PathNodeActionDelegate {
	
	private var _tick :Int16
	private var _pathNodeController :PathNodeController
	private var _shapeNodeController :ShapeNodeController
	
	weak var  _modelActionDelegate: NodesModelActionDelegate?
	
	override init() {
		_tick = 0
		_pathNodeController = PathNodeController()
		_shapeNodeController = ShapeNodeController()
		super.init()
		_shapeNodeController._nodeActionDelegate = self
		_pathNodeController.pathNodeActionDelegate = self
	}
	
	// Mark: PathNodeActionDelegate stubs
	func addPathNodesAt(points: Points) {
		guard let modelActionDelegate = _modelActionDelegate else { return }
		perPoint(points: points) { (x, y) in
			modelActionDelegate.addPathNodeAt(Int(x), Int(y))
		}
	}
	
	
	// Mark: ShapeNodeActionDelegate stubs
	func moveNodes(points :Points, directions :[Direction]) {
		perPoint(points: points, meta: directions, function: {(x:Int16, y:Int16, dir:Direction) in
			print("x: \(x)")
		})
	}
	
	// Mark: NodesModel stubs
	func addPathNodeAt(_ x:Int16, _ y:Int16) {
		//let pathNode = PathNode(Int16(x), Int16(y))
		_pathNodeController.addPathNodeAt(x, y)
	}
	
	func tick() {
		_shapeNodeController.tick()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

protocol NodesModelActionDelegate: NSObjectProtocol {
	func addPathNodeAt(_ x: Int, _ y: Int)
}

protocol ShapeNodeActionDelegate: NSObjectProtocol {
	func moveNodes(points :Points, directions :[Direction])
}
