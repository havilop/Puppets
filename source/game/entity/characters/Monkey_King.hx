package game.entity.characters;


import game.entity.characters.abilities.monkey_king.Bounderless_Strike;
import game.entity.characters.abilities.monkey_king.Jingu_Mastery;
import game.entity.characters.abilities.necrophos.Death_Pulse;
import game.entity.characters.abilities.necrophos.Scythe;
import game.entity.items.Boots;

class Monkey_King extends Entity
{

    public function new() 
    {
        super();

        typeEntity = CHARACTER;

        name = "Monkey King";
        
        setAbilities([Bounderless_Strike,Jingu_Mastery]);

        base_strength = 2;
        increase_strength = 5;

        base_intellect = 5;
        increase_intellect = 4;

    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (this.isClient&& FlxG.keys.justPressed.Z)
        {
            this.addEffect(new Jingu_Mastery_Effet(this,5));
        }

    }
}