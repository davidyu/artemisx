package com.artemisx.test;

import com.artemisx.utils.Bitset;

@:access(com.artemisx.utils.Bitset)
class TestBitset extends haxe.unit.TestCase {
    override public function setup() {
    }

    public function testSanity() {
        var bs = new Bitset( 1 );
        assertFalse( bs.get( 0 ) );
        bs.set( 0 );
        assertTrue( bs.get( 0 ) );

        var bs = new Bitset( 0 );
        assertFalse( bs.get( 0 ) );
        assertEquals( bs.length, Bitset.BITS_PER_WORD );
        // I feel that in a correct implementation, Bitsets of size 0 should have length 0. Oh well...
    }

    public function sub_testSetBit( n : Int ) {
        var bs = new Bitset( n );

        for ( i in 0...n ) {
            assertFalse( bs.get( i ) );
        }

        for ( i in 0...n ) {
            bs.set( i );
            for ( j in 0...i ) {
                assertTrue( bs.get( j ) );
            }
        }

        bs.clear();
        for ( i in 0...n ) {
            assertFalse( bs.get( i ) );
        }

        for ( i in n...0 ) {
            bs.set( i );
            for ( j in i...0 ) {
                assertTrue( bs.get( j ) );
            }
        }
    }

    public function sub_testUnsetBit( n : Int ) {
        var bs = new Bitset( n );

        for ( i in 0...n ) {
            bs.set( i );
        }

        for ( i in 0...n ) {
            assertTrue( bs.get( i ) );
        }

        for ( i in 0...n ) {
            bs.unset( i );
            for ( j in 0...i ) {
                assertFalse( bs.get( j ) );
            }
        }

        for ( i in 0...n ) {
            bs.set( i );
        }

        for ( i in 0...n ) {
            assertTrue( bs.get( i ) );
        }

        for ( i in n...0 ) {
            bs.set( i );
            for ( j in i...0 ) {
                assertFalse( bs.get( j ) );
            }
        }
    }

    public function testGeneral() {
        sub_testSetBit( 10 );
        sub_testUnsetBit( 10 );
        sub_testSetBit( 50 );
        sub_testUnsetBit( 50 );
        sub_testSetBit( 100 );
        sub_testUnsetBit( 100 );
    }

    public function testGeneralStress() {
        sub_testSetBit( 500 );
        sub_testUnsetBit( 500 );
        sub_testSetBit( 1000 );
        sub_testUnsetBit( 1000 );
    }

    public function testNumberOfTrailingZeroes() {
        for ( i in 0...32 ) {
            var x = 1 << i;
            assertEquals( Bitset.numberOfTrailingZeros( x ), i );
        }
    }

    public function testIntersection() {
        var bit = new Bitset(1);
        var bit2 = new Bitset();
        bit.set(33);
        bit2.set(33);
        bit2.set(1);

        assertEquals( bit.intersects( bit2 ), true );
        assertEquals( bit2.intersects( bit ), true );
    }

    public function testIteratorSanity() {
        var bit = new Bitset();
        bit.set(0);
        bit.set(1);

        var iter = bit.iter();
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 0 );
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 1 );
        assertFalse( iter.hasNext() );

        bit.set(2);
        bit.set(4);

        var iter = bit.iter();
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 0 );
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 1 );
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 2 );
        assertTrue( iter.hasNext() );
        assertEquals( iter.next(), 4 );
        assertFalse( iter.hasNext() );
    }

    public function testNextSetBit() {
        // sanity, one word
        var bs = new Bitset( 32 );

        for ( i in 0...32 ) {
            bs.set( i );
        }

        //assertEquals( bs.wordsInUse, 1 );
        //assertEquals( bs.bits.length, 1 );

        for ( i in 0...31 ) {
            assertEquals( bs.nextSetBit( i ), i );
        }

        // two words
        var bs = new Bitset( 64 );

        //assertEquals( bs.wordsInUse, 2 );
        //assertEquals( bs.bits.length, 2 );

        for ( i in 0...64 ) {
            bs.set( i );
        }

        for ( i in 0...63 ) {
            assertEquals( bs.nextSetBit( i ), i );
        }
    }

    public function testIterator() {

        var bs = new Bitset( 500 );
        for ( i in 0...500 ) {
            bs.set( i );
        }

        var numSetBits = 0;
        var iter = bs.iter();

        for ( i in iter ) {
            numSetBits++;
        }

        assertEquals( numSetBits, 500 );
    }
}
