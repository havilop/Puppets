package game.entity.items;

import game.entity.items.abilities.Ability_Card;

class Card extends Item
{
    public var level:Int = 0;
    public function new() 
    {
        super(null,[],Ability_Card,0);
    }    
}