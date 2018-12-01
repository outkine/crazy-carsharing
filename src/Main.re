open Reprocessing;

let width = 15;
let height = 12;
let spritesheetWidth = width * 10;
let spritesheetHeight = height * 10;

class mob (x, y, spritesheet, texPos) = {
  as _;
  val mutable x = x;
  val mutable y = y;
  pub draw = env => {
    print_string(x ++ y);
    Draw.subImage(
      spritesheet,
      ~pos=(x, y),
      ~width,
      ~height,
      ~texPos,
      ~texWidth=spritesheetWidth,
      ~texHeight=spritesheetHeight,
      env,
    );
  };
};

type direction =
  | Left
  | Right;

class player (x, y, spritesheet, texPos) = {
  as _;
  inherit (class mob)(x, y, spritesheet, texPos);
  val mutable velocity = 0;
  val mutable direction = 0;
  pub turn = turnDir =>
    direction =
      direction
      + (
        switch (turnDir) {
        | Right => 1
        | Left => (-1)
        }
      );
  pub accelerate = () => velocity = velocity + 1;
  pub break = () => {
    velocity = velocity - 2;
    if (velocity < 0) {
      velocity = 0;
    };
  };
  pub update = () => x = x + velocity;
};

type state = {player};

let setup = (assetDir, env) => {
  Env.size(~width=600, ~height=600, env);
  let spritesheet =
    Draw.loadImage(
      ~filename=Filename.concat(assetDir, "spritesheet.png"),
      ~isPixel=true,
      env,
    );
  {player: (new player)(0, 0, spritesheet, (0, 0))};
};

let keyPressed = (state, env) => {
  switch (Env.keyCode(env)) {
  | Escape => exit(0)
  | k =>
    switch (k) {
    | Right => state.player#turn(Right)
    | Left => state.player#turn(Left)
    | Up => state.player#accelerate()
    | Down => state.player#break()
    | _ => ()
    }
  };
  state;
};

let draw = (state, env) => {
  Draw.background(Utils.color(~r=255, ~g=255, ~b=255, ~a=255), env);
  state.player#draw(env);
  state;
};

let run = assetDir => run(~setup=setup(assetDir), ~draw, ~keyPressed, ());
