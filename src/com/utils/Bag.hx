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
	
	// This function changes the index of elements... is that right?
    public inline function remove(index:Int):E
    {
        var e:E = data[index];
        data[index] = data[data.length - 1];
        data[data.length - 1] = null;
        return e;
    }

    //gotcha: in the canonical implementation this overloads remove; we changed this to removeElement for clarity.
    public function removeElement(e:E):Bool
    {
        for (index in 0...size)
        {
            var e2:E = data[index];
            if (e2 == e)
            {
                data[index] = data[data.length - 1];
                data[data.length - 1] = null;
                return true;
            }
        }

        return false;
    }
	
	public inline function removeLast():E
	{
		if (data.length > 0) {
			var e:E = data[data.length - 1];
			data[data.length - 1] = null;
			return e;
		}
		return null;
	}
	
	public function contains(e:E):Bool
	{
		for (i in 0...size) {
			if (e == data[i]) {
				return true;
			}
		}
		return false;
	}
	
	public function removeAllIn(bag:ImmutableBag<E>) 
	{
		var modified = false;
		
		for (i in 0...bag.size) {
			var e1:E = bag.get(i);
			var j = 0;
			
			while (j < size) {
				var e2:E = data[j];
				
				if (e1 == e2) {
					remove(j);
					j--;
					modified = true;
					break;
				}
				j++;
			}
		}
		
		return modified;
	}
	
	public function get(index:Int):E
	{
		return data[index];
	}
	
	public function getCapacity():Int
	{
		return data.length;
	}
	
	public function isIndexWithinBounds(index:Int):Bool
	{
		return index < getCapacity();
	}
	
	public function isEmpty():Bool
	{
		return size == 0;
	}
	
	public function add(e:E):Void
	{
		if (size == Std.int(data.length)) {
			grow(size*2);
		}
		
		data[size++] = e;
	}
	
	public function set(index:Int, e:E)
	{
		if (index >= Std.int(data.length)) {
			grow(index << 1);
		}
		size = index + 1;
		data[index] = e;
	}
	
	private function grow(newCapactiy:Int)
	{
		var numToAdd = newCapactiy - data.length;
		while (numToAdd > 0) {
			data.push(null);
			numToAdd--;
		}
	}
	
	public function ensureCapacity(index:Int)
	{
		if (index >= Std.int(data.length)) {
			grow(index * 2); // I think this should be index
		}
	}
	
	public function clear():Void
	{
		for (i in 0...size) {
			data[i] = null;
		}
		size = 0;
	}
	
	public function addAllin(items:ImmutableBag<E> ):Void
	{
		for (i in 0...items.size) {
			add(items.get(i));
		}
	}
	
}
