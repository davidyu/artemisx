package com.artemisx.test;

import com.artemisx.utils.Bag;

@:access(com.artemisx.utils.Bag)
class TestBag extends haxe.unit.TestCase {
    override public function setup() {
    }

    public function testSanity() {
        var b:Bag<Int> = new Bag();
        b.add(5);
        b.add(5);
        b.add(5);
        b.add(7);

        assertEquals( b.get(0), 5 );
        assertEquals( b.get(1), 5 );
        assertEquals( b.get(2), 5 );
        assertEquals( b.get(3), 7 );

        b.set( 10, 6 );
        assertEquals( b.get(10), 6 );

        assertEquals( b.size, 11 );
        b.remove( 2 );
        assertEquals( b.size, 11 );
    }
}
