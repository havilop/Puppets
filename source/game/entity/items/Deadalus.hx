package game.entity.items;

import game.entity.items.abilities.Ability_Deadalus.Abilitiy_Deadalus;

class Deadalus extends Item {
    public function new() 
    {
        super("assets/player/items/deadalus.png",['damagePhysic/55'],Abilitiy_Deadalus,0);    
    }
    
}