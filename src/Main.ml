open Reprocessing
module Decode = Atdgen_codec_runtime.Decode
module KeySet = Reprocessing_Common.KeySet

type response

external fetch : string -> response Repromise.t = "fetch" [@@bs.val]
external json : response -> Js.Json.t Repromise.t = "" [@@bs.send]

let width = 15
let height = 12
let scale = 3
let screen_width = 1920
let screen_height = 1080
let sign n = match n < 0. with true -> -1. | false -> 1.

let absDecrease n decrease =
  let res = n -. (decrease *. sign n) in
  match sign res <> sign n with true -> 0. | false -> res

let lerp n1 n2 t = ((1. -. t) *. n1) +. (t *. n2)

class tilemap tilemapImg tilemapObj tilesheetObj =
  object
    initializer
      tilemapObj.layers
  end

let ( >> ) f g x = g (f x)

class mob x y spritesheet texPos =
  object
    val mutable x : float = x

    val mutable y : float = y

    val mutable rotation = 0.

    method draw env =
      Draw.translate ~x ~y env;
      Draw.rotate rotation env;
      Draw.translate
        ~x:(-1. *. float_of_int (width * scale) /. 2.)
        ~y:(-1. *. float_of_int (height * scale) /. 2.)
        env;
      Draw.subImage spritesheet ~pos:(0, 0) ~width:(width * scale)
        ~height:(height * scale) ~texPos ~texWidth:width ~texHeight:height env
  end

type direction = Left | Right

let turnSpeed = Constants.pi *. 0.03
let friction = 0.2
let airResistence = 0.0001
let acceleration = 1.
let breakFriction = 0.4
let turnSignificance = 0.03

class player x y spritesheet texPos =
  object (this)
    inherit mob x y spritesheet texPos

    val mutable velocityX = 0.

    val mutable velocityY = 0.

    method turn turnDir =
      let dir = match turnDir = Right with true -> 1. | false -> -1. in
      rotation <- rotation +. (turnSpeed *. dir)

    method accelerate () = this#increaseVelocity acceleration

    method break () = this#decreaseVelocity breakFriction

    method update (env : glEnvT) =
      KeySet.iter
        (function
          | Up -> this#accelerate ()
          | Left -> this#turn Left
          | Right -> this#turn Right
          | Down -> this#break ()
          | _ -> ())
        env.keyboard.down;
      this#lerpVelocity turnSignificance;
      this#decreaseVelocityExpo airResistence;
      this#decreaseVelocity friction;
      x <- x +. velocityX;
      y <- y +. velocityY

    method private decreaseVelocity n =
      velocityX <- absDecrease velocityX n;
      velocityY <- absDecrease velocityY n

    method private decreaseVelocityExpo n =
      velocityX <- velocityX -. ((velocityX ** 3.) *. n);
      velocityY <- velocityY -. ((velocityY ** 3.) *. n)

    method private increaseVelocity n =
      velocityX <- velocityX +. (cos rotation *. n);
      velocityY <- velocityY +. (sin rotation *. n)

    method private lerpVelocity n =
      let velocity = sqrt ((velocityX ** 2.) +. (velocityY ** 2.)) in
      velocityX <- lerp velocityX (cos rotation *. velocity) n;
      velocityY <- lerp velocityY (sin rotation *. velocity) n
  end

type state = {player: player; tilemap: tilemap}

let draw state env =
  (state.player)#update env;
  Draw.background (Utils.color ~r:255 ~g:255 ~b:255 ~a:255) env;
  (state.player)#draw env;
  state

let setup assetDir tilemap tilesheet env =
  Env.size ~width:screen_width ~height:screen_height env;
  let loadImage name =
    Draw.loadImage
      ~filename:(Filename.concat assetDir (name ^ ".png"))
      ~isPixel:true env
  in
  let roadsheetImg = loadImage "roadsheet" in
  let tilemapObj = Tilemap_bs.read_tilemap tilemap in
  let tilesheetObj = Tilemap_bs.read_tilesheet tilesheet in
  let tilemap = new tilemap roadsheetImg tilemapObj tilesheetObj in
  let spritesheetImg = loadImage "spritesheet" in
  let player = new player 200. 200. spritesheetImg (0, 0) in
  {player; tilemap}

let keyPressed state env =
  (match Env.keyCode env with Escape -> exit 0 | _ -> ());
  state

let run assetDir tilemap tilesheet =
  run ~setup:(setup assetDir tilemap tilesheet) ~draw ~keyPressed ()
