(* Auto-generated from "tilemap.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type tileset = Tilemap_t.tileset = { firstgid: int; source: string }

type layer = Tilemap_t.layer = { data: int list }

type tilemap = Tilemap_t.tilemap = {
  layers: layer list;
  height: int;
  width: int;
  tilesets: tileset list
}

val read_tileset :  tileset Atdgen_codec_runtime.Decode.t

val write_tileset :  tileset Atdgen_codec_runtime.Encode.t

val read_layer :  layer Atdgen_codec_runtime.Decode.t

val write_layer :  layer Atdgen_codec_runtime.Encode.t

val read_tilemap :  tilemap Atdgen_codec_runtime.Decode.t

val write_tilemap :  tilemap Atdgen_codec_runtime.Encode.t

