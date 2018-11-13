import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Browser.Events exposing (onAnimationFrameDelta)
import Html.Attributes exposing (width, height, style)
import WebGL
import Math.Vector3 exposing (vec3)
import Math.Matrix4
import Json.Decode exposing (Value)

--
-- Test example.
--

init = 0

type Msg
  = Increment
  | Decrement

update msg model =
  case msg of
    Increment -> model + 1
    Decrement -> model - 1

main : Program Value Float Float
main =
    Browser.element
        { init = \_ -> ( 0, Cmd.none )
        , view = view
        , subscriptions = (\_ -> onAnimationFrameDelta Basics.identity)
        , update = (\elapsed currentTime -> ( elapsed + currentTime, Cmd.none ))
        }

--
-- Mesh.
--

type alias Vertex =
  { position : Math.Vector3.Vec3
  , color    : Math.Vector3.Vec3
  }

mesh : WebGL.Mesh Vertex
mesh =
  WebGL.triangles
    [ ( Vertex (Math.Vector3.vec3 0 0 0) (Math.Vector3.vec3 1 0 0)
      , Vertex (Math.Vector3.vec3 1 1 0) (Math.Vector3.vec3 0 1 0)
      , Vertex (Math.Vector3.vec3 1 -1 0) (Math.Vector3.vec3 0 0 1)
      )
    ]

--
-- Shaders.
--

type alias Uniforms =
  { perspective : Math.Matrix4.Mat4
  }

vertexShader : WebGL.Shader Vertex Uniforms { vcolor: Math.Vector3.Vec3 }
vertexShader =
  [glsl|
    attribute vec3 position;
    attribute vec3 color;
    uniform mat4 perspective;
    varying vec3 vcolor;

    void main() {
      gl_Position = perspective * vec4(position, 1.0);
      vcolor = color;
    }
  |]

fragmentShader =
  [glsl|
    precision mediump float;
    varying vec3 vcolor;

    void main () {
      gl_FragColor = vec4(vcolor, 1.0);
    }
  |]

perspective : Float -> Math.Matrix4.Mat4
perspective t =
  Math.Matrix4.mul
    (Math.Matrix4.makePerspective 45 1 0.01 100)
    (Math.Matrix4.makeLookAt (vec3 (4 * cos t) 0 (4 * sin t)) (vec3 0 0 0) (vec3 0 1 0))

view : Float -> Html msg
view t =
    WebGL.toHtml
        [ width 400
        , height 400
        , style "display" "block"
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { perspective = perspective (t / 1000) }
        ]
