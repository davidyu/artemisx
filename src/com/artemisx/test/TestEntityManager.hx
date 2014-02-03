package com.artemisx.test;

import com.artemisx.Entity;
import com.artemisx.EntityManager;
import haxe.Int64;

class TestEntityManager extends haxe.unit.TestCase {
    var mgr : EntityManager;

    public function testBasic() {
        mgr = new EntityManager();
        var e : Entity = mgr.createEntityInstance();

        assertEquals( Int64.compare( mgr.totalCreated, Int64.ofInt( 1 ) ), 0 );

        assertEquals( mgr.activeEntityCount, 0 );

        mgr.onDeleted( e );
        assertEquals( Int64.compare( mgr.totalDeleted, Int64.ofInt( 1 ) ), 0 );
    }
}
