package com.artemis.test;

import com.artemis.World;

class TestWorld extends haxe.unit.TestCase {
    public function testBasic() {
        var w : World = new World();
        var e : EntitySystem = new EntitySystem();
        w.setSystemToProcess( e );
        var e2 : EntitySystem = w.getSystem( EntitySystem );

        assertEquals( e, e2 );
    }
}
