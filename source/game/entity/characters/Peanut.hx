package game.entity.characters;

import game.entity.characters.abilities.crow.Follow_Of_Death;
import game.entity.characters.abilities.peanut.Blink;
import game.entity.characters.abilities.peanut.Shit;


class Peanut extends Entity
{
    public function new() 
    {
        super();    

        typeEntity = CHARACTER;

        name = "SCP 173";
        
        setAbilities([Blink,Shit]);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

    }

}