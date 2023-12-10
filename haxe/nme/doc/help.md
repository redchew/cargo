# Parameter
--platform windows|linux|mac|html5
--cmd build|test

# HTML5 Test
milk --platform html5 --cmd test

# Sample

[project]
name = 'Sample'
module = ['nme']
output = 'build'

[haxe]
source = ['src']
lib = []
target = 'js'

[nme]

[nme.project.meta]
title = 'NME Application'
package = 'org.haxe.nme.ogl'
version = '1.0.0'
company = 'nme'

[nme.project.app]
file = 'Application'
main = 'Main'

[nme.project.window]
width = 640
height = 480
orientation = 'landscape'
fps = 60
background = '0xffffff'
require_shaders = 'true'
resizable = true
hardware = true

[milk.pipeline]
verbose = true