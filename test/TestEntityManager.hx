import com.artemisx.EntityManager;
import haxe.Int64;

class TestEntityManager extends haxe.unit.TestCase {
    var mgr : EntityManager;

    public function testBasic() {
        mgr = new EntityManager();
        var e : Entity = mgr.createEntityInstance();
        assertEquals( Int64.compare( mgr.getTotalCreated(), Int64.ofInt( 1 ) ), 0 );

        assertEquals( mgr.getActiveEntityCount(), 0 );

        mgr.onDeleted( e );
        assertEquals( Int64.compare( mgr.getTotalDeleted(), Int64.ofInt( 1 ) ), 0 );
    }
}
