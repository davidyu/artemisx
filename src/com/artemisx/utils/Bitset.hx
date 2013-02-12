package com.artemisx.utils;

import com.artemisx.utils.TArray;

//only used once in ensureCapacity, consider changing type
typedef INT_TYPE = #if flash9 UInt #else Int #end

// Bit set class based on 
// http://javasourcecode.org/html/open-source/mahout/mahout-0.5/
// org/apache/mahout/cf/taste/impl/common/BitSet.java.html
// AND http://grepcode.com/file/repository.grepcode.com/java/root/
// jdk/openjdk/6-b14/java/util/BitSet.java#BitSet.nextSetBit%28int%29
class Bitset
{   
    private static inline var ADDRESS_BITS_PER_WORD:Int = 0x5;
	private static inline var BITS_PER_WORD :Int = 1 << ADDRESS_BITS_PER_WORD;
	private static inline var BIT_INDEX_MASK :Int = BITS_PER_WORD - 1; // Only last 5 bits used to shift

    private var bits:TArray<Int>;
	public var wordsInUse(default, null):Int;

    public function new(?numBits:Int=1) {
        bits = new TArray();
        ensureCapacity(numBits);
    }

    public inline function ensureCapacity(bitIndex:Int):Void {
        var intsToAdd : Int = (bitIndex >> ADDRESS_BITS_PER_WORD) + 1;
		
        if (intsToAdd >= Std.int(bits.length)) {
            intsToAdd -= bits.length;
            for (i in 0...intsToAdd) {
                bits.push(0);
            }
			wordsInUse = bits.length;
        }
		
    }
	
	public inline function intersects(set:Bitset) 
	{
		var res = false;
		for (i in 0...Std.int(Math.min(bits.length, set.wordsInUse))) {
			if ((bits[i] & set.bits[i]) != 0) {
				res = true;
			}
		}
		return res;
	}
	
	public inline function nextClearBit(fromIndex:Int)
	{
		var wordIndex = fromIndex >> ADDRESS_BITS_PER_WORD;
		var chunk = ~bits[wordIndex] & (BIT_INDEX_MASK << fromIndex);
		var bitsInUse = bits.length * ADDRESS_BITS_PER_WORD;
		
		while (true) {
			if (chunk != 0) {
				var t = numberOfTrailingZeros(chunk);
				return (wordIndex * BITS_PER_WORD) + t;
			} else if (++wordIndex >= bitsInUse) {
				return -1;
			}
			chunk = ~bits[wordIndex];
		}
	}
	
	public function nextSetBit(fromIndex:Int)
	{
		var wordIndex = fromIndex >> ADDRESS_BITS_PER_WORD;
		var chunk = bits[wordIndex] & (BIT_INDEX_MASK << fromIndex);
		var bitsInUse = bits.length * ADDRESS_BITS_PER_WORD;
		
		while (true) {
			if (chunk != 0) {
				var t = numberOfTrailingZeros(chunk);
				return (wordIndex * BITS_PER_WORD) + t;
			} else if (++wordIndex >= wordsInUse) {
				return -1;
			}
			chunk = bits[wordIndex];
		}
	}

    public inline function get(bitIndex:Int):Bool
    {
        #if debug
        if (bitIndex >> ADDRESS_BITS_PER_WORD > Std.int(bits.length)) {
            throw "Attempt to get element out of bounds";
		}
        #end
        return (bits[bitIndex >> ADDRESS_BITS_PER_WORD] & (1 << (bitIndex & BIT_INDEX_MASK))) != 0;
    }

    public inline function set(bitIndex:Int):Void
    {
        ensureCapacity(bitIndex);
        bits[bitIndex >> ADDRESS_BITS_PER_WORD] |= 1 << (bitIndex & BIT_INDEX_MASK);
    }

    public inline function unset(bitIndex:Int):Void
    {
        ensureCapacity(bitIndex);
        bits[bitIndex >> ADDRESS_BITS_PER_WORD] &= ~(1 << (bitIndex & BIT_INDEX_MASK));
		recalulateWordsInUse();
    }

    public function clear():Void
    {
        var length = bits.length;
        for (i in 0...length) {
            bits[i] = 0;
        }
		wordsInUse = 0;
    }
	
	public function isEmpty():Bool
	{
		for (i in bits) {
			if (i != 0) {
				return false;
			}
		}
		return true;
	}
	
	private function recalulateWordsInUse()
	{
		var i = 0;
		
		while (i < Std.int(bits.length)) {
			if (bits[i] != 0) {
				break;
			}
			i++;
		}
		wordsInUse = i;
	}

    public function toString():Void { trace(bits); }
	
	// Find the number of zeroes after the lowest order one bit (rightmost)
	// e.g. for 000100, returns 2... or should
	public static inline function numberOfTrailingZeros(i:Int)
	{
		var n = 31;
		var y, x;
		
		y = i <<16;	if (y != 0) { n -=16; x = y; } else { x = i >>> 16; }
		y = x << 8; if (y != 0) { n -= 8; x = y; }
		y = x << 4; if (y != 0) { n -= 4; x = y; }
		y = x << 2; if (y != 0) { n -= 2; x = y; }
		
		return n - ((x << 1) >>> 31);
	}
}
