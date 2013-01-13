//just demonstrates to me how dynamical casting works

package com.artemis.test;

import com.utils.Bag;
import Type;

private class Base {
    public function new () {}
}

private class SubA extends Base {}
private class SubB extends Base {}
private class SubC extends Base {}

private class SubASub extends SubA {}

class TestGenericClass extends haxe.unit.TestCase {

    var lst : Bag<Base>;
    var typeA: Class<Dynamic>;

    public function testBasic() {

        typeA = SubA; //Class<Dynamci> is just a class, don't need no getClass, which extracts a class from an instance

        lst = new Bag<Base>();

        lst.add(new SubA());
        lst.add(new SubB());
        lst.add(new SubC());


        var a : typeA = null;

        //NOTE TO SELF: you must enclose the cast within the Std.is conditional
        // see http://stackoverflow.com/questions/13374790/dynamic-cast-in-haxe
        if (Std.is(lst.get(0), typeA))
        {
            a = cast lst.get(0);
        }

        var b : SubB = cast(lst.get(1), SubB);
        var c : SubC = cast(lst.get(2), SubC);

        assertTrue( a != null );
    }
}
