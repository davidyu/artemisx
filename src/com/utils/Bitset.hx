package com.utils;

import com.utils.TArray;

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
	private static inline var BIT_INDEX_MASK :Int = BITS_PER_WORD - 1;

    private var bits:TArray<Int>;

    public function new(?numBits:Int=1) {
        bits = new TArray();
        ensureCapacity(numBits);
    }

    public inline function ensureCapacity(bitIndex:Int):Void {
        var intsToAdd : Int = bitIndex >> ADDRESS_BITS_PER_WORD;
		
        if ((bitIndex & (BIT_INDEX_MASK)) != 0) {
            intsToAdd++;
        }
        if (intsToAdd > Std.int(bits.length)) {
            intsToAdd -= bits.length;
            for (i in 0...intsToAdd) {
                bits.push(0);
            }
        }
    }
	
	public inline function nextClearBit(bitIndex:Int)
	{
		
	}
	
	public inline function nextSetBit(bitIndex:Int)
	{
		var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
		var chunk = bits[wordIndex];
		var bitsInUse = bits.length * ADDRESS_BITS_PER_WORD;
		
		while (true) {
			if (chunk != 0) {
				return (wordIndex * BITS_PER_WORD) + chunk;
			} else if (++wordIndex >= bitsInUse) {
				return -1;
			}
			chunk = bits[wordIndex];
		}
	}
	


    public inline function get(bitIndex:Int):Bool
    {
        #if debug
        if (bitIndex >> ADDRESS_BITS_PER_WORD < Std.int(bits.length)) {
            throw "Attempt to get element out of bounds";
		}
        #end
        return (bits[bitIndex >> ADDRESS_BITS_PER_WORD] & (1 << (bitIndex & BIT_INDEX_MASK))) != 0;
    }

    public inline  function set(bitIndex:Int):Void
    {
        ensureCapacity(bitIndex);
        bits[bitIndex >> ADDRESS_BITS_PER_WORD] |= 1 << (bitIndex & BIT_INDEX_MASK);
    }

    public inline function unset(bitIndex:Int):Void
    {
        ensureCapacity(bitIndex);
        bits[bitIndex >> ADDRESS_BITS_PER_WORD] &= ~(1 << (bitIndex & BIT_INDEX_MASK));
    }

    public function clear():Void
    {
        var length = bits.length;
        for (i in 0...length) {
            bits[i] = 0;
        }
    }

    public function toString():Void
    {
        trace(bits);
    }
	
	public static inline function numberOfTrailingZeros(i:Int)
	{
		
	}
}
