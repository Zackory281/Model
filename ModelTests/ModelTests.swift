//
//  ModelTests.swift
//  ModelTests
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import XCTest
@testable import Model

class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let map:Map = Map()
		let shapeNode = ShapeNode(pathNode: nil)
		var node:PathNode = generateNodes(points: [0,0, 1,0, 1,1, 1,2, 1,3, ])!
		while node.hasNext() {
			node = node.next()
		}
		map.addTailNodes(tailNode: generateNodes(points: [0,0, 1,0, 1,1, 1,2, 1,3, ])!)
		map.addTailNodes(tailNode: generateNodes(points: [3,3, 3,4, 3,5, 4,5, 5,5,])!)
		map.addShapeNodeToTail(shapeNode: shapeNode)
		print(map.toString())
		print(map.toString())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
