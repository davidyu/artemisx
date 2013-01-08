package com.artemis;

import com.util.Bitset;
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

class Aspect
{
    private var allSet : Bitset;
    private var exclusionSet : Bitset;
    private var oneSet : Bitset;

    private new()
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

    private getOneSet() : Bitset
    {
        return oneSet;
    }

    //TODO: figure out how to implement generics, even if with ClassHash
    //Small gotcha: in contrast with Ari's cannonical implementation, the types
    //parameter is an iterable rather than zero-or-more actual parameters
    public function all(type : Dynamic, ?types : Iterable<Dynamic>) : Aspect
    {
        allSet.set(ComponentType.getIndexFor(type));

        if (types != null)
        {
            for (t in types)
            {
                allSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public function exclude(type : Class<Component>, ?types : Iterable<Class<Component>>) : Aspect
    {
        exclusionSet.set(ComponentType.getIndexFor(type));
        if (types != null)
        {
            for (t in types)
            {
                exclusionSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public function one(type : Class<Component>, ?types : Iterable<Class<Component>>) : Aspect
    {
        oneSet.set(ComponentType.getIndexFor(type));
        if (types != null)
        {
            for (t in types)
            {
                oneSet.set(ComponentType.getIndexFor(t));
            }
        }

        return this;
    }

    public static function getAspectForAll(type : Class<Component>, ?types : Iterable<Class<Component>>) : Aspect
    {
        Aspect aspect = new Aspect();
        aspect.all(type, types);
        return aspect;
    }

    public static function getAspectForOne(type : Class<Component>, ?types : Iterable<Class<Component>>) : Aspect
    {
        Aspect aspect = new Aspect();
        aspect.all(type, types);
        return aspect;
    }

    public static function getEmpty() : Aspect
    {
        return new Aspect();
    }

}
