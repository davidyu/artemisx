import com.utils.UUID;

class TestUUID extends haxe.unit.TestCase {
    var format : EReg;

    override public function setup() {
        format = ~/[0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12}/;
    }

    public function testFormat() {
        var uuid : String = UUID.getUuid();
        assertTrue( format.match( uuid ) );
    }

    //simple uniqueness test
    public function testUniqueness() {
        var u1 : String = UUID.getUuid();
        var u2 : String = UUID.getUuid();
        assertTrue( u1 != u2 );
    }

    //rigorous uniqueness test
    public function testUniquenessSomeMore() {
        var num : Int = 100;
        var u = new Array<String>();

        for ( i in 0 ... num ) {
            u.push( UUID.getUuid() );
            //neko.Lib.print(u[i] + "\n");
        }

        var allUnique : Bool = true;

        for ( i in 0 ... num ) {
            for ( j in i+1 ... num ) {
                if ( u[i] == u[j] ) {
                    allUnique = false;
                }
            }
        }

        assertTrue( allUnique );
    }
}
