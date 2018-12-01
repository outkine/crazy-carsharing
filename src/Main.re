open Reprocessing;

let width = 15;
let height = 12;
let scale = 3;
let screen_width = 1920;
let screen_height = 1080;

let keyDown = (keyCode, env : Reprocessing_Common.glEnv) =>
  Reprocessing_Common.KeySet.mem(keyCode, env.keyboard.down);

class mob (x, y, spritesheet, texPos) = {
  as _;
  val mutable x: int = x;
  val mutable y: int = y;
  val mutable rotation = 0.;
  pub draw = env => {
    Draw.translate(~x=float_of_int(x), ~y=float_of_int(y), env);
    Draw.rotate(rotation, env);
    Draw.translate(
      ~x=(-1.) *. float_of_int(width * scale) /. 2.,
      ~y=(-1.) *. float_of_int(height * scale) /. 2.,
      env,
    );
    Draw.subImage(
      spritesheet,
      ~pos=(0, 0),
      ~width=width * scale,
      ~height=height * scale,
      ~texPos,
      ~texWidth=width,
      ~texHeight=height,
      env,
    );
  };
};

type direction =
  | Left
  | Right;

let turnSpeed = Constants.pi *. 0.01;

class player (x, y, spritesheet, texPos) = {
  inherit (class mob)(x, y, spritesheet, texPos);
  val mutable velocity = 0.;
  pub turn = turnDir =>
    rotation = rotation +. turnSpeed *. (turnDir == Right ? 1. : (-1.0));
  pub accelerate = () => velocity = velocity +. 1.;
  pub break = () => {
    velocity = velocity *. 0.95;
    if (velocity < 0.1) {
      velocity = 0.;
    };
  };
  pub update = (env) => {
    if (keyDown(Up, env)) this#accelerate()
    if (keyDown(Left, env)) this#turn(Left)
    if (keyDown(Right, env)) this#turn(Right)
    if (keyDown(Down, env)) this#break()

    x = x + int_of_float(cos(rotation) *. velocity);
    y = y + int_of_float(sin(rotation) *. velocity);
  };
};

type state = {player};

let setup = (assetDir, env) => {
  Env.size(~width=screen_width, ~height=screen_height, env);
  let spritesheet =
    Draw.loadImage(
      ~filename=Filename.concat(assetDir, "spritesheet.png"),
      ~isPixel=true,
      env,
    );
  {player: (new player)(200, 200, spritesheet, (0, 0))};
};

let keyPressed = (state, env) => {
  switch (Env.keyCode(env)) {
  | Escape => exit(0)
  | _ => ()
  }
  state;
};

let draw = (state, env) => {
  state.player#update(env);

  Draw.background(Utils.color(~r=255, ~g=255, ~b=255, ~a=255), env);
  state.player#draw(env);
  state;
};

let run = assetDir => run(~setup=setup(assetDir), ~draw, ~keyPressed, ());
