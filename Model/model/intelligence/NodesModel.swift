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
	weak var _guiDelegate: GUIDelegate?
	
	convenience override init() {
		self.init(guiDelegate: nil)
	}
	
	init(guiDelegate: GUIDelegate?) {
		_tick = 0
		_guiDelegate = guiDelegate
		_pathNodeController = PathNodeController(width: MAP_WIDTH, height: MAP_HEIGHT)
		_shapeNodeController = ShapeNodeController()
		super.init()
		_shapeNodeController._nodeActionDelegate = self
		_pathNodeController._pathNodeActionDelegate = self
	}
	
	// Mark: PathNodeActionDelegate stubs
	func uiAddPathNodes(nodes: [Node]) {
		_modelActionDelegate?.uiAddPathNodes(nodes)
		//perPoint(points: point, meta: <#T##[T]#>, function: <#T##(Int16, Int16, T) -> ()#>)
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
	
	func addPathNodesFromTail(points: Points) {
		let head = generateNodesHead(points: points)!
		_pathNodeController.addHeadNode(head)
	}
	
	func loadModel() {
		_pathNodeController.addHeadNode(generateNodesHead(points: [0,0, 0,1, 0,2, 1,2, 2,2, 2,3, 3,3, 4,3, 5,3, 6,3, 7,3])!)
	}
	
	func tick() -> Bool {
		_tick += 1
		_shapeNodeController.tick()
		return false
	}
	
	func getTick() -> Int16 {
		return _tick
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let MAP_WIDTH: Int16 = 200, MAP_HEIGHT: Int16 = 200

protocol NodesModelActionDelegate: NSObjectProtocol {
	func uiAddPathNodes(_ nodes: [Node])
}

protocol ShapeNodeActionDelegate: NSObjectProtocol {
	func moveNodes(points :Points, directions :[Direction])
}
