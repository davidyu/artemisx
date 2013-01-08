package com.artemis.test;

class ArtemisTest {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add( new TestUUID() );
        r.add( new TestEntityManager() );
        r.add( new TestAspect() );
        r.run();
    }
}
