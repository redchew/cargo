package ef;

import flixel.FlxGame;

class Main extends FlxGame
{
    override public function create()
    {
        super.create();

        var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
        text.screenCenter();
        add(text);        
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}