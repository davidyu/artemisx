package com.artemis.test;

import com.artemis.World;
import com.artemis.EntitySystem;

private class DummySystemA extends EntitySystem {}
private class DummySystemB extends EntitySystem {}

class TestWorld extends haxe.unit.TestCase {
    public function testSystem() {
        var w : World = new World();

        var a : DummySystemA = new DummySystemA();
        var b : DummySystemB = new DummySystemB();

        w.setSystemToProcess( a );
        w.setSystemToProcess( b );

        var a2 : DummySystemA = w.getSystem( DummySystemA );
        var b2 : DummySystemB = w.getSystem( DummySystemB );

        //if this worked a == a2 and b == b2

        assertEquals( a, a2 );
        assertEquals( b, b2 );
    }
}
