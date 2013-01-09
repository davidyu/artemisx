package com.artemis;

import com.utils.Bag;

private class Base {}

private class SubA extends Base {}
private class SubB extends Base {}
private class SubC extends Base {}

private class SubASub extends SubA {}

class TestGenericClass extends haxe.unit.TestCase {

    var lst : Bag<Base> subs;

    public function testBasic() {
        lst.add(new SubA());
        lst.add(new SubB());
        lst.add(new SubC());
        assertTrue( true );
    }
}
