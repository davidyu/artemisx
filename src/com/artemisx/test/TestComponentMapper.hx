package com.artemisx.test;

import com.artemisx.Component;

class ComponentA implements Component { }
class ComponentB implements Component { }

class TestComponentMapper extends haxe.unit.TestCase {

    public function testBasic() {
        var cm : ComponentMapper<ComponentA> = new ComponentMapper<ComponentA>();
        assertTrue(true);
    }
}
