package milk.kha;

import milk.kha.Types.EKhaGraphicsAPI;
import milk.kha.Types.ETargetPlatform;

typedef KhaModuleDoc = {
	docPath:String,
	?source:Array<String>,
	?lib:Array<String>,
    
	?target:String,
	?output:String,

    graphicsAPI:EKhaGraphicsAPI,
    platform:ETargetPlatform,
}

typedef KhaSDKDoc = {
	path:String
}

typedef KhaKromDoc = {
	path:String
}

typedef KhaDoc = {
	sdk:KhaSDKDoc,
	?library:String,
	?krom:KhaKromDoc,

	assets:Array<String>,

	?width:Int,
	?height:Int,

	noCompilation:Bool,
}