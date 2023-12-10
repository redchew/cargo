package milk.nme;

typedef MetaDoc = {
    ?title:String,
    ?identifier:String,
    ?version:String,
    ?company:String,
    ?author:String,
}

typedef ApplicationDoc = {

}

typedef WindowDoc = {
    ?width:Int,
    ?height:Int,
    ?orientation:String,
    ?fps:Int,
    ?background:String,
    ?require_shader:Bool,
    ?resizable:Bool,
    ?hardware:Bool
}

typedef ProjectDoc = {
    ?meta:MetaDoc,
    ?app:ApplicationDoc,
    ?window:WindowDoc,
}

typedef AssetDoc = {
    ?path:String,
    ?rename:String,
    ?include:String,
    ?exclude:String,
    ?type:String
}