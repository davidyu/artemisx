package com.artemisx.test;

import com.artemisx.utils.UUID;

@:access(com.artemisx.utils.UUID)
class TestUUID extends haxe.unit.TestCase {
    var format : EReg;

    override public function setup() {
        format = ~/[0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12}/;
    }

    public function testPRNG() {
        var seed = Math.floor( Math.random() * UUID.M31 );
        var rand = UUID.next( seed );
        var u = new Array<Int>();

        for ( i in 0...20 ) {
            rand = UUID.next( rand );
            u.push( rand );
        }

        var allUnique : Bool = true;

        for ( i in 0...20 ) {
            for ( j in i+1...20 ) {
                if ( u[i] == u[j] ) {
                    allUnique = false;
                }
            }
        }

        assertTrue( allUnique );
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
