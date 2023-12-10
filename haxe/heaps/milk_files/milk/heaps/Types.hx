package milk.heaps;

typedef HeapsAssetDoc = {
	path:String,
	relative:Bool,
}

typedef HeapsResourceDoc = {
	path:String,
	relative:Bool,
}

typedef HeapsDoc = {
	?asset:HeapsAssetDoc,
	?resource:HeapsResourceDoc,
	width:Int,
	height:Int,
}