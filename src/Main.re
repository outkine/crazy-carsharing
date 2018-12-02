open Reprocessing;

let width = 15;
let height = 12;
let scale = 3;
let screen_width = 1920;
let screen_height = 1080;

let sign = n => n < 0. ? (-1.) : 1.;
let absDecrease = (n, decrease) => {
  let res = n -. decrease *. sign(n);
  sign(res) != sign(n) ? 0. : res;
};

let lerp = (n1, n2, t) => (1. -. t) *. n1 +. t *. n2;

let keyDown = (keyCode, env: Reprocessing_Common.glEnv) =>
  Reprocessing_Common.KeySet.mem(keyCode, env.keyboard.down);

class mob (x, y, spritesheet, texPos) = {
  as _;
  val mutable x: float = x;
  val mutable y: float = y;
  val mutable rotation = 0.;
  pub draw = env => {
    Draw.translate(~x, ~y, env);
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
let turnSpeed = Constants.pi *. 0.03;
let friction = 0.2;
let airResistence = 0.0001;
let acceleration = 1.;
let breakFriction = 0.4;
let turnSignificance = 0.03;

class player (x, y, spritesheet, texPos) = {
  inherit (class mob)(x, y, spritesheet, texPos);
  val mutable velocityX = 0.;
  val mutable velocityY = 0.;
  pub turn = turnDir =>
    rotation = rotation +. turnSpeed *. (turnDir == Right ? 1. : (-1.0));
  pub accelerate = () => this#increaseVelocity(acceleration);
  pub break = () => this#decreaseVelocity(breakFriction);
  pri decreaseVelocity = n => {
    velocityX = absDecrease(velocityX, n);
    velocityY = absDecrease(velocityY, n);
  };
  pri decreaseVelocityExpo = n => {
    velocityX = velocityX -. velocityX ** 3. *. n;
    velocityY = velocityY -. velocityY ** 3. *. n;
  };
  pri increaseVelocity = n => {
    velocityX = velocityX +. cos(rotation) *. n;
    velocityY = velocityY +. sin(rotation) *. n;
  };
  pri lerpVelocity = n => {
    let velocity = sqrt(velocityX ** 2. +. velocityY ** 2.);
    velocityX = lerp(velocityX, cos(rotation) *. velocity, n);
    velocityY = lerp(velocityY, sin(rotation) *. velocity, n);
  };
  pub update = env => {
    if (keyDown(Up, env)) {
      this#accelerate();
    };
    if (keyDown(Left, env)) {
      this#turn(Left);
    };
    if (keyDown(Right, env)) {
      this#turn(Right);
    };
    if (keyDown(Down, env)) {
      this#break();
    };

    this#lerpVelocity(turnSignificance);
    this#decreaseVelocityExpo(airResistence);
    this#decreaseVelocity(friction);

    x = x +. velocityX;
    y = y +. velocityY;
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
  {player: (new player)(200., 200., spritesheet, (0, 0))};
};

let keyPressed = (state, env) => {
  switch (Env.keyCode(env)) {
  | Escape => exit(0)
  | _ => ()
  };
  state;
};

let draw = (state, env) => {
  (state.player)#update(env);

  Draw.background(Utils.color(~r=255, ~g=255, ~b=255, ~a=255), env);
  (state.player)#draw(env);
  state;
};

let run = assetDir => run(~setup=setup(assetDir), ~draw, ~keyPressed, ());
