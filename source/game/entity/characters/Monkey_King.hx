package game.entity.characters;


import game.entity.buildings.tower.TowerAttack;
import game.entity.characters.abilities.monkey_king.Bounderless_Strike;
import game.entity.characters.abilities.monkey_king.Jingu_Mastery;
import game.entity.characters.abilities.necrophos.Death_Pulse;
import game.entity.characters.abilities.necrophos.Ghost_Shroud.Necrophos_Effect_Ghost_Shroud;
import game.entity.characters.abilities.necrophos.Scythe;
import game.entity.items.Boots;

class Monkey_King extends Entity
{

    public function new() 
    {

		super();

        typeEntity = CHARACTER;
		mainAttribute = AGILITY;
        name = "Monkey King";
        
		setAbilities([Bounderless_Strike, Jingu_Mastery]);

		base_strength = 19;
		increase_strength = 2.8;

		base_intellect = 20;
		increase_intellect = 1.8;


    }
    override function update(elapsed:Float) {
        super.update(elapsed);



    }
}