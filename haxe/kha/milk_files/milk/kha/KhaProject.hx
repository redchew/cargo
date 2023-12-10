package milk.kha;

typedef Resource = {
    id:String,
    path:String,
}

typedef KhaProject = {
    name:String,
    sources:Array<String>,
    mainclass:String,
    ?libraries:Array<String>,
    ?definitions:Array<String>,
    ?extras:Array<String>,
    ?assets:Array<String>,
    ?resource:Array<Resource>,

    ?width:Int,
    ?height:Int,
}