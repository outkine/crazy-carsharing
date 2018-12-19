external tilemap : Js.Json.t = "../../../assets/tilemap.json" [@@bs.module]
external tilesheet : Js.Json.t = "../../../assets/roadsheet.json" [@@bs.module]

let _ = Main.run "./assets" tilemap tilesheet
