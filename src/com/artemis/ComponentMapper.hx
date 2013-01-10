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
		return new ComponentMapper<T>(type, world);
	}

    private function new(type:Class<A>, world:World)
    {
		// Use untyped to work around the loss of parameter constraint
        this.type = ComponentType.getTypeFor(untyped type); 
        components = world.cm.getComponentsByType(this.type);
        this.classType = type;
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
