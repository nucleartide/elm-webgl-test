import Browser
import Html exposing (div, text)
import Browser.Events exposing (onAnimationFrameDelta)
import Json.Decode exposing (Value)
import WebGL
import Math.Vector2 exposing (vec2)
import Math.Vector3 exposing (vec3)
import Math.Vector4 exposing (vec4)
import Html.Attributes exposing (width, height, style)

main : Program Value Float Float
main =
  Browser.element
    -- Initial command.
    { init = \_ -> (0, Cmd.none)

    -- View function.
    , view = view

    -- Emit time deltas to your view function.
    , subscriptions = \_ -> onAnimationFrameDelta Basics.identity

    -- Update function.
    , update = \elapsed currentTime -> (elapsed + currentTime, Cmd.none)
    }

type alias Point =
  { position : Math.Vector2.Vec2
  }

white = vec4 (255/255) (241/255) (232/255) 1

newPoint x y =
  Point (vec2 (x+0.5) (y+0.5))

points : WebGL.Mesh Point
points =
  WebGL.points
    [

      newPoint 64 64
    , newPoint 65 64

    , newPoint 64 65
    , newPoint 65 65

    , newPoint 64 66
    , newPoint 65 66

    , newPoint 64 67
    , newPoint 65 67

    , newPoint 64 68
    , newPoint 65 68

    , newPoint 64 69
    , newPoint 65 69

    , newPoint 64 70
    , newPoint 65 70

    --

    , newPoint (64+5) 64
    , newPoint (65+5) 64

    , newPoint (64+5) 65
    , newPoint (65+5) 65

    , newPoint (64+5) 66
    , newPoint (65+5) 66

    , newPoint (64+5) 67
    , newPoint (65+5) 67

    , newPoint (64+5) 68
    , newPoint (65+5) 68

    , newPoint (64+5) 69
    , newPoint (65+5) 69

    , newPoint (64+5) 70
    , newPoint (65+5) 70

    --

    , newPoint 66 68
    , newPoint 67 68
    , newPoint 68 68

    --

    , newPoint (64+9) 64
    , newPoint (65+9) 64

    , newPoint (64+9) 65
    , newPoint (65+9) 65

    , newPoint (64+9) 66
    , newPoint (65+9) 66

    , newPoint (64+9) 67
    , newPoint (65+9) 67

    , newPoint (64+9) 68
    , newPoint (65+9) 68

    , newPoint (64+9) 69
    , newPoint (65+9) 69

    , newPoint (64+9) 70
    , newPoint (65+9) 70

    --

    , newPoint (64+13) 64
    , newPoint (65+13) 64

    , newPoint (64+13) 65
    , newPoint (65+13) 65

    , newPoint (64+13) 66
    , newPoint (65+13) 66

    , newPoint (64+13) 67
    , newPoint (65+13) 67

    , newPoint (64+13) 68
    , newPoint (65+13) 68

    , newPoint (64+13) 69
    , newPoint (65+13) 69

    , newPoint (64+13) 70
    , newPoint (65+13) 70

    --

    , newPoint (64+17) 64
    , newPoint (65+17) 64

    , newPoint (64+17) 65
    , newPoint (65+17) 65

    , newPoint (64+17) 66
    , newPoint (65+17) 66

    , newPoint (64+17) 67
    , newPoint (65+17) 67

    , newPoint (64+17) 68
    , newPoint (65+17) 68

    , newPoint (64+17) 69
    , newPoint (65+17) 69

    , newPoint (64+17) 70
    , newPoint (65+17) 70

    ]

view t =
  WebGL.toHtmlWith
    [ WebGL.clearColor (255/255) (119/255) (168/255) 1
    ]
    [ width 128
    , height 128
    , style "display" "block"
    ]
    [
      WebGL.entity
        vertexShader
        fragmentShader
        points
        { resolution = vec2 128 128
        , color = white
        }
    ]

vertexShader =
  [glsl|
    attribute vec2 position;
    uniform   vec2 resolution;

    void main() {
      vec2 clipSpace = (position / resolution) * 2.0 - 1.0;
      vec2 flipped   = clipSpace * vec2(1, -1);
      gl_PointSize   = 1.0;
      gl_Position    = vec4(flipped, 0, 1);
    }
  |]

fragmentShader =
  [glsl|
    precision mediump float;
    uniform   vec4    color;

    void main() {
      gl_FragColor = color;
    }
  |]
