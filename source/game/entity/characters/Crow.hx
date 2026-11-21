package game.entity.characters;

import game.entity.characters.abilities.crow.Follow_Of_Death;

class Crow extends Entity
{
    public function new() 
    {
        super();    

        typeEntity = CHARACTER;

        name = "Crow";
        
        setAbilities([Follow_Of_Death]);
    }
}