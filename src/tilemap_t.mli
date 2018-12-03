(* Auto-generated from "tilemap.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type tileset = { firstgid: int; source: string }

type layer = { data: int list }

type tilemap = {
  layers: layer list;
  height: int;
  width: int;
  tilesets: tileset list
}
