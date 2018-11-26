import Foundation

public class WeakSet<T: AnyObject>: Sequence, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible {
	
	private var objects = NSHashTable<T>.weakObjects()
	
	public init(_ objects: [T]) {
		for object in objects {
			insert(object)
		}
	}
	
	public convenience required init(arrayLiteral elements: T...) {
		self.init(elements)
	}
	
	public var allObjects: [T] {
		return objects.allObjects
	}
	
	public var count: Int {
		return objects.count
	}
	
	public func contains(_ object: T) -> Bool {
		return objects.contains(object)
	}
	
	public func insert(_ object: T) {
		objects.add(object)
	}
	
	public func remove(_ object: T) {
		objects.remove(object)
	}
	
	public func makeIterator() -> AnyIterator<T> {
		let iterator = objects.objectEnumerator()
		return AnyIterator {
			return iterator.nextObject() as? T
		}
	}
	
	public var description: String {
		return objects.description
	}
	
	public var debugDescription: String {
		return objects.debugDescription
	}
}
