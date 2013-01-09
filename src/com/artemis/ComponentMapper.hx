package com.artemis;

import com.artemis.World;
import com.artemis.Component;
import com.utils.Bag;

// Maybe investigate component map creator instead of static to allow haxe.rtti.Generic

class ComponentMapper<A:Component>
{
    private var type:ComponentType;
    private var classType:Class<A>;
    private var components:Bag<Component>;
	
	public static function getFor<T:Component>(type:Class<T>, world:World)
	{
		var res:ComponentMapper<T> = new ComponentMapper<T>(type, world);
		return res;
	}

    private function new(type:Class<A>, world:World)
    {
		//trace(type);
        //this.type = ComponentType.getTypeFor(type);
    }
	
	public function get(e:Entity):A
	{
		return untyped components.get(e.id);
	}
	
	public function getSafe(e:Entity):A
	{
		if (components.isIndexWithinBounds(e.id)) {
			return cast(components.get(e.id));
		}
		return null;
	}
	
	public function has(e:Entity) 
	{
		return getSafe(e) != null;
	}
}
