package com.artemisx.test;

@:access(com.artemisx)
class ArtemisTest {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add( new TestUUID() );
        r.add( new TestEntityManager() );
        r.add( new TestAspect() );
        r.add( new TestWorld() );
        //r.add( new TestComponentMapper() );
        r.run();
    }
}
