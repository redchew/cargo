package ;

import nme.display.Sprite;
import nme.display.OpenGLView;
import nme.display.BitmapData;
import nme.gl.GL;
import nme.gl.GLBuffer;
import nme.gl.GLProgram;
import nme.gl.GLTexture;
import nme.utils.UInt8Array;
import nme.utils.Float32Array;
import nme.utils.ArrayBuffer;
import nme.utils.ArrayBufferView;
import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import nme.geom.Rectangle;

class Simple extends Sprite
{
   public function new()
   {
      super();

      var ogl = new OpenGLView();
      ogl.scrollRect = new nme.geom.Rectangle(0,0,400,300);
      ogl.x = 100;
      ogl.y = 100;

      // create frame buffer...
      var frameBuffer = GL.createFramebuffer();
      GL.bindFramebuffer(GL.FRAMEBUFFER, frameBuffer);
      GL.bindFramebuffer(GL.FRAMEBUFFER, null);

      // var renderbuffer = GL.createRenderbuffer();
      // GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);

      addChild(ogl);

      ogl.render = function(rect:Rectangle)
      {
                  // Use the display list rectangle..
         var w = rect.width;
         var h = rect.height;
         GL.viewport(Std.int(rect.x), Std.int(rect.y), Std.int(w), Std.int(h));

         GL.clearColor(0.1,0.2,0.5,1);

         // Rener old buffer...
         quad.render();
      }
   }
}
