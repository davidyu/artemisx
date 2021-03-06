package com.artemisx.utils;
import haxe.ds.StringMap;

/*
 * Wrapper for a Hash to allow Class types to be used as keys 
 */
using Type;
using Lambda;

class ClassHash<V>
{
	private var map:haxe.ds.StringMap<V>;
	
	public function new():Void
	{
		map = new StringMap();
	}
	
	public inline function set(key:Class<Dynamic>, value:V):Void
	{
		map.set(key.getClassName(), value);
	}

	public inline function get(key:Class<Dynamic>):Null<V>
	{
		return map.get(key.getClassName());
	}

	public inline function exists(key:Class<Dynamic>):Bool
	{
		return map.exists(key.getClassName());
	}

	public inline function remove(key:Class<Dynamic>):Bool
	{
		return map.remove(key.getClassName());
	}

	public inline function keys():Iterator<Class<Dynamic>>
	{
		// TODO test this function
		return mymap(map.keys(), function(v:String) { return v.resolveClass(); } );
	}

	public inline function iterator():Iterator<V>
	{
		return map.iterator();
	}

	public inline function toString():String
	{
		return map.toString();
	}
	
	// Not sure if there is better solution but Lambda.map does not allow iterator as parameter..
	private static inline function mymap<A,B>(it:Iterator<A>, f:A -> B) : Iterator<B> {
		var l = new List<B>();
		for( x in it )
			l.add(f(x));
		return l.iterator();
	}
}
