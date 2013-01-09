package com.artemis;

import com.utils.Bitset;
import StdTypes;

/**
 * Used by Systems to match against groups of entities.
 * This may be conceptually difficult to understand, so read
 * Ari's comments about it here:
 *
 *    http://gamadu.com/artemis/manual.html#Aspect
 *    http://gamadu.com/artemis/javadoc/com/artemis/Aspect.html
 *
 * originally written by Arni Arent
 * ported to HaXe by Lewen Yu
 */

@:allow(com.artemis.test.TestAspect) //test hook
class Aspect
{
    public var allSet (getAllSet, null) : Bitset;
    public var exclusionSet (getExclusionSet, null) : Bitset;
    public var oneSet (getOneSet, null) : Bitset;

    private function new()
    {
        this.allSet = new Bitset();
        this.exclusionSet = new Bitset();
        this.oneSet = new Bitset();
    }

    private function getAllSet() : Bitset
    {
        return allSet;
    }

    private function getExclusionSet() : Bitset
    {
        return exclusionSet;
    }

    private function getOneSet() : Bitset
    {
        return oneSet;
    }

    //Small gotcha: in contrast with Ari's cannonical implementation, the types
    //parameter is an iterable rather than zero-or-more actual parameters
    public function all(types : Iterable<Class<Component>>) : Aspect
    {
        if (types != null)
        {
            for (t in types)
            {
                allSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public function exclude(types : Iterable<Class<Component>>) : Aspect
    {
        if (types != null)
        {
            for (t in types)
            {
                exclusionSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public function one(types : Iterable<Class<Component>>) : Aspect
    {
        if (types != null)
        {
            for (t in types)
            {
                oneSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public static function getAspectForAll(types : Iterable<Class<Component>>) : Aspect
    {
        var aspect = new Aspect();
        aspect.all(types);
        return aspect;
    }

    public static function getAspectForOne(types : Iterable<Class<Component>>) : Aspect
    {
        var aspect = new Aspect();
        aspect.one(types);
        return aspect;
    }

    public static function getEmpty() : Aspect
    {
        return new Aspect();
    }

}
