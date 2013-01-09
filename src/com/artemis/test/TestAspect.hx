package com.artemis.test;

import com.artemis.Aspect;
import com.artemis.Component;

//TODO: rewrite this test when World is done

class DummyComponent implements Component { }

class TestComponent implements Component { }

class TestAspect extends haxe.unit.TestCase {
    public function testBasic() {
        var aspect = Aspect.getAspectForAll( [DummyComponent, TestComponent] );
        var allSet = aspect.getAllSet();
        var exclusionSet = aspect.getExclusionSet();
        var oneSet = aspect.getOneSet();
        assertTrue( true );
    }
}
