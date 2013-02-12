package com.artemisx;

import com.artemisx.utils.ClassHash;

@:allow(com.artemisx)
class ComponentType
{	
	public var index(get_index, null):Int;
	
	public static inline function getIndexFor(c:Class<Component>) { return getTypeFor(c).index; }
	
	public static inline function getTypeFor(c:Class<Component>):ComponentType
	{
		var type:ComponentType = componentTypes.get(c);
		
		if (type == null) {
			type = new ComponentType(c);
			componentTypes.set(c, type);
			componentIndicies.push( type );
		}
		return type;
	}
	
	public static inline function getTypeFromIndex( index : Int ) : Class<Component> {
		return componentIndicies[index].type;
	}
	
	public static function listAllComponentTypes() : Void {
		var str : String = "";
		var arr : Array<ComponentType> = [];
		
		for ( i in componentTypes.iterator() ) {
			arr.push( i );
		}
		arr.sort( typeIndexComparator );
		
		for ( i in arr ) {
			str += i.toString();
		}
		
		trace( str );
	}
	
	private static var componentTypes:ClassHash<Component, ComponentType> = new ClassHash();
	private static var componentIndicies:Array<ComponentType> = new Array();
	private static var INDEX:Int = 0;
	
	private var type:Class<Component>;
	
	private static inline function typeIndexComparator( a : ComponentType, b : ComponentType ) : Int {
		var res = 0;
		if ( a.index > b.index ) {
			res = 1;
		} else if ( a.index < b.index ) {
			res = -1;
		}
		return res;
	}
	
	private function new(type:Class<Component>) 
	{
		index = INDEX++;
		this.type = type;
	}
	
	public inline function get_index():Int { return index; }
	
	public function toString() { return "(" + index + ": " + classFormatter( type ) + ")" ; }
	
	private static function classFormatter( clazz : Class<Component> ) : String {
		var classname = Type.getClassName( clazz );
		var lastPeriod = classname.lastIndexOf( "." ) + 1;
		return classname.substring( lastPeriod );
	}
	
}