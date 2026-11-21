package game.entity.items;


import game.entity.characters.abilities.monkey_king.Jingu_Mastery;
import game.entity.items.abilities.Ability_Boots;

class Boots extends Item
{
    public function new() 
    {
        super("assets/player/items/boots.png",["health_regeneration/50"],Ability_Boots,500);   
    }
}   