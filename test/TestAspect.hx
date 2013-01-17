import com.artemisx.Aspect;
import com.artemisx.Component;

//TODO: rewrite this test when World is done

private class ComponentA implements Component { }
private class ComponentB implements Component { }

@:access(com.artemisx.Aspect)
//needs Haxe 2.11!!!
class TestAspect extends haxe.unit.TestCase {

    public function testBasic() {
        var aspect = Aspect.getAspectForAll( [ComponentA, ComponentB] );
        //var allSet = aspect.getAllSet();
        //var exclusionSet = aspect.getExclusionSet();
        //var oneSet = aspect.getOneSet();
        assertTrue( true );
    }
}
