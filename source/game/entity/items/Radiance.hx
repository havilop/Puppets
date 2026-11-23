package game.entity.items;


import game.entity.characters.abilities.monkey_king.Jingu_Mastery;
import game.entity.items.abilities.Abilitiy_Radiance.Ability_Radiance;

class Radiance extends Item
{
    public function new() 
    {
		super("assets/player/items/radiance.png", ["damagePhysic/55", "evasion/100"], Ability_Radiance, 0);   
    }
}   