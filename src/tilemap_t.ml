(* Auto-generated from "tilemap.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type tilesheet = {tileheight: int; tilewidth: int; columns: int}
type tileset = {firstgid: int}
type layer = {data: int list}

type tilemap =
  {layers: layer list; height: int; width: int; tilesets: tileset list}
