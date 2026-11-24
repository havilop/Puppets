package game.entity.characters;
import game.entity.characters.abilities.monkey_king.Jingu_Mastery;
import game.entity.characters.abilities.necrophos.Death_Pulse;
import game.entity.characters.abilities.necrophos.Death_Seeker;
import game.entity.characters.abilities.necrophos.Ghost_Shroud;
import game.entity.characters.abilities.necrophos.HeartStopped_Aura;
import game.entity.characters.abilities.necrophos.Sadist;
import game.entity.characters.abilities.necrophos.Scythe;
class Necrophos extends Entity
{

    public function new() 
    {
		baseRangeAttack = 500;
        super();
        typeEntity = CHARACTER;

        name = "Necrophos";

        mainAttribute = INTELLECT;

		baseSpeedAttack = 112;
		projectileSpeed = 1200;
		intervalAttack = 0.77;

        base_strength = 18;
        increase_strength = 2.3;

        base_intellect = 23;
        increase_intellect = 2.7;

        base_health_regeneration = 0.25;
        base_mana_regeneration = 100;
  
        setAbilities([Death_Pulse,Ghost_Shroud,Death_Seeker,Scythe,HeartStopped_Aura]);

    }    
}   