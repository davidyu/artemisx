package com.utils;

/*
 * Wrapper for a Hash to allow Class types to be used as keys 
 */
using Type;
using Lambda;

class ClassHash<K, V>
{
	private var map:Hash<V>;
	
	public function new():Void
	{
		map = new Hash();
	}
	
	public inline function set(key:Class<K>, value:V):Void
	{
		map.set(key.getClassName(), value);
	}

	public inline function get(key:Class<K>):Null<V>
	{
		return map.get(key.getClassName());
	}

	public inline function exists(key:Class<K>):Bool
	{
		return map.exists(key.getClassName());
	}

	public inline function remove(key:Class<K>):Bool
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
