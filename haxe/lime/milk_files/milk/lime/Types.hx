package milk.lime;

typedef LimeProjectMetaDoc = {
    ?title:String,
    ?identifier:String,
    ?version:String,
    ?company:String,
    ?author:String,
}

typedef LimeProjectDoc = {
    
}

typedef LimeDoc = {

}

typedef LimeAssetDoc = {
    ?path:String,
    ?rename:String,
    ?include:String,
    ?exclude:String,
    ?type:String
}