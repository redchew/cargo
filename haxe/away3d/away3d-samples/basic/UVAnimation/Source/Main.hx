/*

UV animation example in Away3d

Demonstrates:
How to use the UVAnimator.

Code by Fabrice Closier
fabrice3d@gmail.com
http://www.closier.nl

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package;

import away3d.animators.UVAnimationSet;
import away3d.animators.UVAnimator;
import away3d.animators.data.UVAnimationFrame;
import away3d.animators.nodes.UVClipNode;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.materials.TextureMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.textures.BitmapTexture;

import openfl.display.*;
import openfl.events.*;
import openfl.geom.Vector3D;
import openfl.Assets;
 

class Main extends Sprite
{
	//engine variables
	private var _view:View3D;

	function new()
	{
		super();
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		setUpView();

		setUpUVAnimators();

		addEventListener(Event.ENTER_FRAME, _onEnterFrame);
	}

	/**
	* view setup
	*/
	private function setUpView():Void
	{
		_view = new View3D();
		addChild(_view);
		
		_view.antiAlias = 2;

		_view.camera.x = 500;
		_view.camera.y = 500;
		_view.camera.z = -1500;

		//saving the origin, as we look at it on enterframe
		_view.camera.lookAt(new Vector3D());

		stage.addEventListener(Event.RESIZE, onResize);
		onResize();
	}

	/**
	* render loop
	*/
	private function _onEnterFrame(e:Event):Void
	{	
		_view.render();
	}
	
	/**
	 * stage listener for resize events
	 */
	private function onResize(event:Event = null):Void
	{
		_view.width = stage.stageWidth;
		_view.height = stage.stageHeight;
	}

	/**
	* setup of the UVAnimators
	*/
	private function setUpUVAnimators():Void
	{						
		//the vars we will reuse
		var animID:String;
		var pg:PlaneGeometry = new PlaneGeometry(500, 500,1 ,1, false);
		var diffuse:BitmapData;
		var bt:BitmapTexture;
		var mat:TextureMaterial;
		var mesh:Mesh;
		var uvAnimationSet:UVAnimationSet;
		var uvAnimator:UVAnimator;

		//In this demo class, the two upper planes, will be using non- keyframe information
		//while the two others will display keyframe based animations

		//All the animations are non destructive (the mesh uvs are kept unchanged) and very efficient as they are executed on the gpu.

		//Endless rotations, map scrolls are very useful. They are hard to define using keyframes.
		//UVAnimator offers both options without the need to define any keyframes.

		/* 1: The top left plane, will display the endless rotation of a image*/
		animID = "anim_rotation";
		//material declaration
		diffuse = Assets.getBitmapData("assets/wheel.png");
		bt = new BitmapTexture(diffuse);
		mat = new TextureMaterial(bt);
		
		// adding an empty set with our animation id
		uvAnimationSet = generateBlankAnimationSet(animID);
		uvAnimator = new UVAnimator(uvAnimationSet);
		//setting the animator autoRotation
		uvAnimator.autoRotation = true;
		uvAnimator.rotationIncrease = 1.1; //default is 1 degree

		// the geometry receiver
		mesh = new Mesh(pg, mat);
		//assigning the animator to the mesh
		mesh.animator = uvAnimator;
		//let's play our animation
		uvAnimator.play(animID); 
		mesh.x -= 300;
		mesh.y += 300;
		_view.scene.addChild(mesh);


		/* 2: The top right plane, will display the endless scroll of an image*/
		animID = "anim_translate";
		diffuse = Assets.getBitmapData("assets/road.jpg");
		bt = new BitmapTexture(diffuse);
		mat = new TextureMaterial(bt);
		// the road map that we use is seamless, so we set repeat to true to prevent elongated pixel
		mat.repeat = true;
		
		uvAnimationSet = generateBlankAnimationSet(animID);
		uvAnimator = new UVAnimator(uvAnimationSet);
		// setting the auto translate
		uvAnimator.autoTranslate = true;
		// in this example we scroll a endless road, so the increase is made only along the v axis
		// note that using integers values would not affect the rendering. The image would stay still as the uvs are using values between 0 and 1.
		uvAnimator.setTranslateIncrease(0, -.01);
		uvAnimator.play(animID);
		mesh = new Mesh(pg, mat);
		mesh.animator = uvAnimator;
		mesh.x += 300;
		mesh.y += 300;
		_view.scene.addChild(mesh);


		/* 3: The down left plane, will display an animation using keyframes.*/
		animID = "anim3";
		//material setup, similar to the above examples
		diffuse = Assets.getBitmapData("assets/wheel.png");
		bt = new BitmapTexture(diffuse);
		mat = new TextureMaterial(bt);
		mat.repeat = true;
		// this time, we use a keyframe based approach.
		uvAnimationSet = generateFirstAnimation(animID);
		uvAnimator = new UVAnimator(uvAnimationSet);
		mesh = new Mesh(pg, mat);
		mesh.animator = uvAnimator;
		uvAnimator.play(animID);
		mesh.x += 300;
		mesh.y -= 300;
		_view.scene.addChild(mesh);


		/* 4: The down right plane, will display another animation using another set of keyframes. */
		animID = "anim4";
		diffuse = Assets.getBitmapData("assets/wheel.png");
		bt = new BitmapTexture(diffuse);
		mat = new TextureMaterial(bt);
		mat.repeat = true;
		mesh = new Mesh(pg, mat);
		uvAnimationSet = generateSecondAnimation(animID);
		uvAnimator = new UVAnimator(uvAnimationSet);
		mesh.animator = uvAnimator;
		uvAnimator.play(animID);
		mesh.x -= 300;
		mesh.y -= 300;
		_view.scene.addChild(mesh);

	}

	/**
	 * adding a blank set, to meet the generic animators architecture
	 */
	private function generateBlankAnimationSet(animID:String) : UVAnimationSet
	{
		var uvAnimationSet:UVAnimationSet = new UVAnimationSet();
		var node:UVClipNode = new UVClipNode();
		node.name = animID;
		uvAnimationSet.addAnimation(node);

		return uvAnimationSet;
	}

	/**
	 * adding set, composed of multiple keyframes
	 */
	private function generateFirstAnimation(animID:String) : UVAnimationSet
	{
		var uvAnimationSet:UVAnimationSet = new UVAnimationSet();

		var node:UVClipNode = new UVClipNode();
		node.name = animID;
		uvAnimationSet.addAnimation(node);
		  
		var frame:UVAnimationFrame;
		var duration:Int = 1000;
		var offset:Float = 0;

	 	frame = new UVAnimationFrame();
		frame.offsetU = offset;
		frame.offsetV = offset;
		frame.scaleU = 1;
		frame.scaleV = 1;
		frame.rotation = 0;

		node.addFrame(frame, duration);
		 
	 	frame = new UVAnimationFrame();
		frame.offsetU =  offset;
		frame.offsetV =  offset;
		frame.scaleU = 2;
		frame.scaleV = 2;
		frame.rotation = 0;

		node.addFrame(frame, duration);

	 	frame = new UVAnimationFrame();
		frame.offsetU = offset;
		frame.offsetV = offset;
		frame.scaleU = 1;
		frame.scaleU = 1;
		frame.rotation = 90;

		node.addFrame(frame, duration);

	 	frame = new UVAnimationFrame();
		frame.offsetU = offset;
		frame.offsetV = offset;
		frame.scaleU = 1;
		frame.scaleU = 1;
		frame.rotation = 90;

		node.addFrame(frame, duration);

	 	frame = new UVAnimationFrame();
		frame.offsetU = offset;
		frame.offsetV = offset;
		frame.scaleU = 1;
		frame.scaleU = 1;
		frame.rotation = 90;

		node.addFrame(frame, duration);

		return uvAnimationSet;
	}


	private function generateSecondAnimation(animID:String) : UVAnimationSet
	{
		var uvAnimationSet:UVAnimationSet = new UVAnimationSet();
		var node:UVClipNode = new UVClipNode();
		node.name = animID;
		uvAnimationSet.addAnimation(node);
		  
		var frame:UVAnimationFrame;

	 	frame = new UVAnimationFrame();
		node.addFrame(frame, 250);

		frame = new UVAnimationFrame();
		frame.scaleU =  frame.scaleV = 4;
		node.addFrame(frame, 1000);

		return uvAnimationSet;
	}

}