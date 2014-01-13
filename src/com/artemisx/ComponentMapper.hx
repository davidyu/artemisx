package com.artemisx;

import com.artemisx.World;
import com.artemisx.Component;
import com.artemisx.utils.Bag;

/**
 * ComponentMapper
 * originally written by Arni Arent
 * ported to HaXe by Team Yu
 */

@:allow(com.artemisx)
class ComponentMapper<A:Component>
{
    private var type:ComponentType;
    private var classType:Class<A>;
    private var components:Bag<Component>;

    public static function getFor<T:Component>(type:Class<T>, world:World):ComponentMapper<T>
    {
        return new ComponentMapper<T>(type, world);
    }

    private function new(type:Class<A>, world:World)
    {
        // Use untyped to work around the loss of parameter constraint
        this.type = ComponentType.getTypeFor(untyped type); 
        components = world.componentManager.getComponentsByType(this.type);
        this.classType = type;
    }

    public inline function get(e:Entity):A { return untyped components.get(e.id); }

    public inline function getSafe(e:Entity):A
    {
        var res : A = null;
        if (components.isIndexWithinBounds(e.id)) {
            res = cast(components.get(e.id));
        }
        return res;
    }

    public inline function has(e:Entity) { return getSafe(e) != null; }
}
