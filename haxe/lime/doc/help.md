# Parameter
--platform windows|linux|mac|html5
--cmd build|test

# HTML5 Test
milk --platform html5 --cmd test

# Version
Lime	->	7.1.1
OpenFL	->	8.5.0
Flixel	->	4.5.1

# Asset
[lime.project.assets.{default}]
path = 'assets/images'
rename = 'images'
include = '*.jpg | *.png'
exclude = 'example.jpg'
type = 'image'

[lime.project.assets.audio.sound]
path = 'sound/MySound.wav'
id = 'MySound'

[lime.project.assets.audio.music]
path = 'sound/BackgroundMusic.ogg'

# Default

[lime.project.window]
width = 1280
height = 720
background = '#FFFFFF'
fps = 60
hardware = true
allow-shaders = true
depth-buffer = false
stencil-buffer = false
fullscreen = false
resizable = false
borderless = false
vsync = true
oridentation = 'landscape'