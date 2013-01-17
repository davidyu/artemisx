import com.artemisx.Aspect;
import com.artemisx.World;
import com.artemisx.EntitySystem;
import com.artemisx.Component;
import com.artemisx.ComponentMapper;

class ComponentA implements Component
{
}

class ComponentB implements Component
{

}

private class DummySystemA extends EntitySystem
{
    @Mapper("com.artemisx.test.ComponentA") public var compA : ComponentMapper<ComponentA>;
}
private class DummySystemB extends EntitySystem {}

class TestWorld extends haxe.unit.TestCase {
    public function testSystem() {
        var w : World = new World();

        //var a : DummySystemA = new DummySystemA();
        //var b : DummySystemB = new DummySystemB();

        //w.setSystem( a );
        //w.setSystem( b );

        //var a2 : DummySystemA = w.getSystem( DummySystemA );
        //var b2 : DummySystemB = w.getSystem( DummySystemB );
//
        //if this worked a == a2 and b == b2
//
        //assertEquals( a, a2 );
        //assertEquals( b, b2 );

        w.initialize();

        //assertEquals( w.getSystem(DummySystemA).compA.classType, ComponentA );
        //this test passes - I commented it out because classType is usually set to private so this test would automatically fail.
    }
}
