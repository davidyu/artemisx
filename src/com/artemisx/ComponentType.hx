package com.artemisx;

import com.artemisx.utils.ClassHash;

/**
 * ComponentType
 * originally written by Arni Arent
 * ported to HaXe by Team Yu
 */

@:allow(com.artemisx)
class ComponentType
{
    public var index(get_index, null):Int;

    public static inline function getIndexFor(c:Class<Component>) { return getTypeFor(c).index; }

    public static inline function getTypeFor(c:Class<Component>):ComponentType
    {
        var type:ComponentType = componentTypes.get(c);

        if (type == null) {
            type = new ComponentType(c);
            componentTypes.set(c, type);
            componentIndicies.push( type );
        }
        return type;
    }

    public static inline function getTypeFromIndex( index : Int ) : Class<Component> {
        return componentIndicies[index].type;
    }

#if debug
    public static function traceAllComponentTypes() : Void {
        trace( nameListOfAllComponentTypes() );
    }

    public static function nameListOfAllComponentTypes() : Array<String> {
        var cmplist : Array<ComponentType> = [];
        var namelist : Array<String>    = [];

        for ( i in componentTypes.iterator() ) {
            cmplist.push( i );
        }

        cmplist.sort( typeIndexComparator );

        for ( c in cmplist ) {
            namelist.push( c.toString() );
        }

        return namelist;
    }
#end

    private static var componentTypes:ClassHash<ComponentType> = new ClassHash<ComponentType>();
    private static var componentIndicies:Array<ComponentType> = new Array();
    private static var INDEX:Int = 0;

    private var type:Class<Component>;

    private static inline function typeIndexComparator( a : ComponentType, b : ComponentType ) : Int {
        var res = 0;
        if ( a.index > b.index ) {
            res = 1;
        } else if ( a.index < b.index ) {
            res = -1;
        }
        return res;
    }

    private function new(type:Class<Component>) 
    {
        index = INDEX++;
        this.type = type;
    }

    public inline function get_index():Int { return index; }

    public function toString() { return "(" + index + ": " + className( type ) + ")" ; }

    private static function className( clazz : Class<Component> ) : String {
        var classname = Type.getClassName( clazz );
        var lastPeriod = classname.lastIndexOf( "." ) + 1;
        return classname.substring( lastPeriod );
    }
}
