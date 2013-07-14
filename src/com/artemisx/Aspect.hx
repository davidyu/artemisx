package com.artemisx;

import com.artemisx.utils.Bitset;
import StdTypes;

/**
 * Used by Systems to match against groups of entities.
 * This may be conceptually difficult to understand, so read
 * Ari's comments about it here:
 *
 *    http://gamadu.com/artemisx/manual.html#Aspect
 *    http://gamadu.com/artemisx/javadoc/com/artemis/Aspect.html
 *
 * originally written by Arni Arent
 * ported to HaXe by Lewen Yu and Harry
 */

@:allow(com.artemisx)
class Aspect
{
    @:isVar private var allSet (get_allSet, null):Bitset;
    @:isVar private var exclusionSet (get_exclusionSet, null):Bitset;
    @:isVar private var oneSet (get_oneSet, null):Bitset;

    private function new()
    {
        this.allSet = new Bitset();
        this.exclusionSet = new Bitset();
        this.oneSet = new Bitset();
    }

    private inline function get_allSet():Bitset { return allSet; }
    private inline function get_exclusionSet():Bitset { return exclusionSet; }
    private inline function get_oneSet():Bitset { return oneSet; }

    //Small gotcha: in contrast with Ari's cannonical implementation, the types
    //parameter is an iterable rather than zero-or-more actual parameters
    public function all(types:Iterable<Class<Component>>):Aspect
    {
        if (types != null) {
            for (t in types) {
                allSet.set(ComponentType.getIndexFor(t));
            }
        }
        return this;
    }

    public function exclude(types:Iterable<Class<Component>>):Aspect
    {
        if (types != null) {
            for (t in types) {
                exclusionSet.set(ComponentType.getIndexFor(t));
            }
        }
        return this;
    }

    public function one(types:Iterable<Class<Component>>):Aspect
    {
        if (types != null) {
            for (t in types) {
                oneSet.set(ComponentType.getIndexFor(t));
            }
        }
        return this;
    }

    public static inline function getAspectForAll(types:Iterable<Class<Component>>):Aspect
    {
        var aspect = new Aspect();
        aspect.all(types);
        return aspect;
    }

    public static inline function getAspectForOne(types:Iterable<Class<Component>>):Aspect
    {
        var aspect = new Aspect();
        aspect.one(types);
        return aspect;
    }

    public static inline function getEmpty():Aspect { return new Aspect(); }

}
