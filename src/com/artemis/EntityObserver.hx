/**
 *
 * The EntityObserver interface. Used for subscribing/listening to entity events
 *  originally written by Arni Arent
 *  ported to HaXe by Lewen Yu
 *
 */

package com.artemis;

interface EntityObserver {

    function added(Entity e);

    function changed(Entity e);

    function deleted(Entity e);

    function enabled(Entity e);

    function disabled(Entity e);

}

