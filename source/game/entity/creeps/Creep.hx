package game.entity.creeps;

class Creep extends Entity 
{
    public function new() 
    {
        super();   
        
        typeEntity = CREEP_LINE;
        name = "Creep";
        team = neutral;
        level = 4;
    }    
} 