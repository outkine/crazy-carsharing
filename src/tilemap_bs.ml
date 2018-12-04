(* Auto-generated from "tilemap.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type tilesheet = Tilemap_t.tilesheet =
  {tileheight: int; tilewidth: int; columns: int}

type tileset = Tilemap_t.tileset = {firstgid: int}
type layer = Tilemap_t.layer = {data: int list}

type tilemap = Tilemap_t.tilemap =
  {layers: layer list; height: int; width: int; tilesets: tileset list}

let write_tilesheet =
  Atdgen_codec_runtime.Encode.make (fun (t : tilesheet) ->
      Atdgen_codec_runtime.Encode.obj
        [ Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"tileheight" t.tileheight
        ; Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"tilewidth" t.tilewidth
        ; Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"columns" t.columns ] )

let read_tilesheet =
  Atdgen_codec_runtime.Decode.make (fun json ->
      ( { tileheight=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "tileheight" )
              json
        ; tilewidth=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "tilewidth" )
              json
        ; columns=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "columns" )
              json }
        : tilesheet ) )

let write_tileset =
  Atdgen_codec_runtime.Encode.make (fun (t : tileset) ->
      Atdgen_codec_runtime.Encode.obj
        [ Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"firstgid" t.firstgid ] )

let read_tileset =
  Atdgen_codec_runtime.Decode.make (fun json ->
      ( { firstgid=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "firstgid" )
              json }
        : tileset ) )

let write__3 = Atdgen_codec_runtime.Encode.list Atdgen_codec_runtime.Encode.int
let read__3 = Atdgen_codec_runtime.Decode.list Atdgen_codec_runtime.Decode.int

let write_layer =
  Atdgen_codec_runtime.Encode.make (fun (t : layer) ->
      Atdgen_codec_runtime.Encode.obj
        [Atdgen_codec_runtime.Encode.field write__3 ~name:"data" t.data] )

let read_layer =
  Atdgen_codec_runtime.Decode.make (fun json ->
      ( { data=
            Atdgen_codec_runtime.Decode.decode
              (read__3 |> Atdgen_codec_runtime.Decode.field "data")
              json }
        : layer ) )

let write__2 = Atdgen_codec_runtime.Encode.list write_tileset
let read__2 = Atdgen_codec_runtime.Decode.list read_tileset
let write__1 = Atdgen_codec_runtime.Encode.list write_layer
let read__1 = Atdgen_codec_runtime.Decode.list read_layer

let write_tilemap =
  Atdgen_codec_runtime.Encode.make (fun (t : tilemap) ->
      Atdgen_codec_runtime.Encode.obj
        [ Atdgen_codec_runtime.Encode.field write__1 ~name:"layers" t.layers
        ; Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"height" t.height
        ; Atdgen_codec_runtime.Encode.field Atdgen_codec_runtime.Encode.int
            ~name:"width" t.width
        ; Atdgen_codec_runtime.Encode.field write__2 ~name:"tilesets"
            t.tilesets ] )

let read_tilemap =
  Atdgen_codec_runtime.Decode.make (fun json ->
      ( { layers=
            Atdgen_codec_runtime.Decode.decode
              (read__1 |> Atdgen_codec_runtime.Decode.field "layers")
              json
        ; height=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "height" )
              json
        ; width=
            Atdgen_codec_runtime.Decode.decode
              ( Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "width" )
              json
        ; tilesets=
            Atdgen_codec_runtime.Decode.decode
              (read__2 |> Atdgen_codec_runtime.Decode.field "tilesets")
              json }
        : tilemap ) )
