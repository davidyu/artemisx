package com.artemis;

import com.artemis.annotations.World;
import com.artemis.Component;
import com.utils.TArray;
import haxe.macro.Type;

class ComponentMapper<A:Component> implements haxe.rtti.Generic
{
    private var type:ComponentType;
    private var classType:Class<Dynamic>;
    private var components:TArray<Component>;

    private function new(type:Class<Dynamic>, world:World)
    {
        this.type = ComponentType.getTypeFor(type);
        //components = world.getComponentManager().getComponentsByType(this.type)
        this.classType = type;
    }

    public function get( e : Entity ) : A
    {
        
    }
}
