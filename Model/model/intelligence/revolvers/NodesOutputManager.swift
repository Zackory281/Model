//
//  NodesModelExtension.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesOutputManager: NSObject, OutputDelegate {
	
	weak var _modelActionDelegate: NodesModelActionDelegate?
	
	// Mark: NodeActionDelegate stubs
	func uiAddNodes(nodes: [Node]) {
		_modelActionDelegate?.uiAddNodes(nodes)
	}
	
	func uiUpdateNodes(nodes: [Node]) {
		_modelActionDelegate?.uiUpdateNodes(nodes)
	}
	
	func tick(_ tick :Int16) {
		
	}
}
