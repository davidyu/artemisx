package com.artemisx;

import com.utils.ClassHash;

@:allow(com.artemisx)
class ComponentType
{
	private static var componentTypes:ClassHash<Component, ComponentType> = new ClassHash();
	private static var INDEX:Int = 0;
	
	public var index(getIndex, null):Int;
	private var type:Class<Component>;
	
	public static inline function getIndexFor(c:Class<Component>) { return getTypeFor(c).index; }
	
	public static inline function getTypeFor(c:Class<Component>):ComponentType
	{
		var type:ComponentType = componentTypes.get(c);
		
		if (type == null) {
			type = new ComponentType(c);
			componentTypes.set(c, type);
		}
		return type;
	}
	
	private function new(type:Class<Component>) 
	{
		index = INDEX++;
		this.type = type;
	}
	
	public inline function getIndex():Int { return index; }
	
	public function toString() { return "ComponentType[" + Type.getClassName(type) + "] (" + index + ")"; }
	
}