package com.utils;

// Bit set class based on 
// http://javasourcecode.org/html/open-source/mahout/mahout-0.5/org/apache/mahout/cf/taste/impl/common/BitSet.java.html
class Bitset 
{
	private static inline var numbits:Int = 0x1F;
	private static inline var powertwo:Int = 0x5;
	
	private var bits:Array<Int>;
	
	public function new(length:Int) 
	{
		var ints = length >> powertwo;
		if ((length & (numbits)) != 0) {
			ints++;
		}
		
		bits = new Array();
		for (i in 0...ints) {
			bits.push(0);
		}
	}
	
	public function get(index:Int):Bool
	{
		return (bits[index >> powertwo] & 1 << (index & numbits)) != 0;
	}
	
	public function set(index:Int):Void
	{
		bits[index >> powertwo] |= 1 << (index & numbits);
	}
	
	public function unset(index:Int):Void
	{
		bits[index >> powertwo] &= ~(1 << (index & numbits));
	}
	
	public function reset():Void
	{
		var length = bits.length;
		for (i in 0...length) {
			bits[i] = 0;
		}
	}
	
	public function trace():Void
	{
		trace(bits);
	}
}