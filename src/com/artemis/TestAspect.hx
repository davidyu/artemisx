package com.artemis;

import com.artemis.Aspect;
import com.artemis.Component;

//TODO: rewrite this test when World is done

private class ComponentA implements Component { }
private class ComponentB implements Component { }

class TestAspect extends haxe.unit.TestCase {

    public function testBasic() {
        var aspect = Aspect.getAspectForAll( [ComponentA, ComponentB] );
        var allSet = aspect.getAllSet();
        var exclusionSet = aspect.getExclusionSet();
        var oneSet = aspect.getOneSet();
        assertTrue( true );
    }
}
