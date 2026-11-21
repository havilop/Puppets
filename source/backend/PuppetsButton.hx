package backend;

class PuppetsButton extends FlxSprite
{
    public var onClick:Void -> Void;
    public var onOver:Void -> Void;
    public var onOut:Void -> Void;
    var wasOverlaping:Bool = false;
    var _isPressed:Bool = false;
    public var text:FlxText;
    public var visualOverlaps:Bool = true;
    public var CAMERa:FlxCamera;

    

    public function new(X:Float,Y:Float,TEXT:String,FUNCTION:Void -> Void,CAMERA:FlxCamera) 
    {
     super(X,Y,null);
     super.makeGraphic(150,25,FlxColor.WHITE);
     super.updateHitbox();

     this.onClick = FUNCTION;
     CAMERa = CAMERA;

  

     text = new FlxText(0,0,0,TEXT,22);
     text.font = Path.font;
     text.color = FlxColor.BLACK;
     updateText();

     


     this.onOver = function name() {
     
     }
     this.onOut = function name() {
 
     }
    }

    override function draw() {
        super.draw();


        text.draw();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        text.update(elapsed);
        
        text.x = this.x + (this.width / 2) - (text.fieldWidth / 2);
        text.y = this.y + (this.height / 2) - (text.fieldHeight / 2);

        var overlaps:Bool = this.overlapsPoint(FlxG.mouse.getWorldPosition(CAMERa));

        if (overlaps && FlxG.mouse.justPressed)
        {
            _isPressed = true;
        }

        if (overlaps && FlxG.mouse.justReleased && _isPressed && this.visible)  
        {
            onClick();
          
            _isPressed = false;
        }
        if (overlaps && this.visible)
        {
            if (visualOverlaps)
            {
                this.color = 0xA5A5A5;
            }
            onOver();
            wasOverlaping = true;
        }
        if (!overlaps && wasOverlaping == true && this.visible)
        {
            if (visualOverlaps)
            {
                this.color = 0xFFFFFF;
            }
            onOut();
            wasOverlaping = false;
        }
        
    }
    public function updateText() 
    {
        text.x = (this.width / 2) - (text.fieldWidth / 2);
        text.y = (this.height / 2) - (text.fieldHeight / 2);    
    }
    
}