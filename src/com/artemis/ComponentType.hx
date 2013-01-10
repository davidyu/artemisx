package com.artemis;
import com.utils.ClassHash;

class ComponentType
{
	// Static members
	private static var componentTypes:ClassHash<Component, ComponentType> = new ClassHash();
	private static var INDEX:Int = 0;
	
	// Non-static members
	public var index(getIndex, null):Int;
	private var type:Class<Component>;
	
	// Static functions
	public static function getTypeFor(c:Class<Component>):ComponentType
	{
		var type:ComponentType = componentTypes.get(c);
		
		if (type == null) {
			type = new ComponentType(c);
			componentTypes.set(c, type);
		}
		
		return type;
	}
	
	public static function getIndexFor(c:Class<Component>)
	{
		return getTypeFor(c).index;
	}
	
	// Non static functions
	private function new(type:Class<Component>) 
	{
		index = INDEX++;
		this.type = type;
	}
	
	public function getIndex():Int
	{
		return index;
	}
	
	public function toString()
	{
		return "ComponentType[" + Type.getClassName(type) + "] (" + index + ")";
	}
	
}