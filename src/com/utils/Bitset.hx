package com.utils;

import com.utils.TArray;

// Bit set class based on 
// http://javasourcecode.org/html/open-source/mahout/mahout-0.5/org/apache/mahout/cf/taste/impl/common/BitSet.java.html
class Bitset 
{
    private static inline var bitsInInt:Int = 0x1F;
    private static inline var powertwo:Int = 0x5;

    private var bits:TArray<Int>;

    public function new(numBits:Int) 
    {
        bits = new TArray();
        ensureCapacity(numBits);
    }

    public inline function ensureCapacity(index:Int):Void
    {
        var intsToAdd:UInt = index >> powertwo;
        if ((index & (bitsInInt)) != 0) {
            intsToAdd++;
        }
        if (intsToAdd > bits.length) {
            intsToAdd -= bits.length;
            for (i in 0...intsToAdd) {
                bits.push(0);
            }
        }
    }

    public function get(index:Int):Bool
    {
        #if debug
        if (index >> powertwo < Std.int(bits.length))
            throw "Attempt to get element out of bounds";
        #end
        return (bits[index >> powertwo] & 1 << (index & bitsInInt)) != 0;
    }

    public function set(index:Int):Void
    {
        ensureCapacity(index);
        bits[index >> powertwo] |= 1 << (index & bitsInInt);
    }

    public function unset(index:Int):Void
    {
        ensureCapacity(index);
        bits[index >> powertwo] &= ~(1 << (index & bitsInInt));
    }

    public function reset():Void
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
}
