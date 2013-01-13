package com.utils;

/**
 * Maybe one day there will be something faster and this class would allow us to
 * switch to a faster data struct without modifying any other code
 */

class Bag<E> implements ImmutableBag<E>
{
	private var data:TArray<E>;
	public var size(default, null):Int;
	
	public function new(?capacity:Int=64) 
	{
		data = new TArray();
		size = 0;
		for (i in 0...capacity) {
			data.push(null);
		}
		
	}
	
	// TODO Test this function. Swap and pop changes order, and some classes depend on e.id as index
    public inline function removeAt(index:Int):E
    {
        var e:E = data[index];
        data[index] = data[--size];
        data[size] = null;
        return e;
    }

    // gotcha: in the canonical implementation this overloads remove; We have removeAt for index remove
    public inline function remove(e:E):Bool
    {
        for (index in 0...size) {
            var e2:E = data[index];
            if (e2 == e)
            {
                data[index] = data[--size];
                data[size] = null;
                return true;
            }
        }
        return false;
    }
	
	public inline function removeLast():E
	{
		if (size > 0) {
			var e:E = data[--size];
			data[size] = null;
			return e;
		}
		return null;
	}
	
	public inline function contains(e:E):Bool
	{
		for (i in 0...size) {
			if (e == data[i]) {
				return true;
			}
		}
		return false;
	}
	
	public inline function removeAllIn(bag:ImmutableBag<E>) 
	{
		var modified = false;
		
		for (i in 0...bag.size) {
			var e1:E = bag.get(i);
			var j = 0;
			
			for (j in 0...size) {
				var e2:E = data[j];
				
				if (e1 == e2) {
					removeAt(j);
					j--;
					modified = true;
					break;
				}
			}
		}
		return modified;
	}
	
	public inline function get(index:Int):E { return data[index]; }
	
	public inline function getCapacity():Int { return data.length; }
	
	public inline function isIndexWithinBounds(index:Int):Bool { return index < getCapacity(); }
	
	public inline function isEmpty():Bool { size == 0; }

	
	public inline function add(e:E):Void
	{
		if (size == Std.int(data.length)) {
			grow(size << 1);
		}
		data[size++] = e;
	}
	
	public inline function set(index:Int, e:E)
	{
		if (index >= Std.int(data.length)) {
			grow(index << 1);
		}
		size = index + 1;
		data[index] = e;
	}
	
	private inline function grow(newCapactiy:Int)
	{
		var numToAdd = newCapactiy - data.length;
		for (i in 0...numToAdd) {
			data.push(null);
		}
	}
	
	public inline function ensureCapacity(index:Int)
	{
		if (index >= Std.int(data.length)) {
			grow(index * 2); // I think this should be index
		}
	}
	
	public inline function clear():Void
	{
		for (i in 0...size) {
			data[i] = null;
		}
		size = 0;
	}
	
	public inline function addAllin(items:ImmutableBag<E> ):Void
	{
		for (i in 0...items.size) {
			add(items.get(i));
		}
	}
	
	public function toString():Void
	{
		trace(data);
	}
	
}
