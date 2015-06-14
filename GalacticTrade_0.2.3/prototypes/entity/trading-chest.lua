data:extend({
  {
      type = "container",
      name = "trading-chest-buy",
      icon = "__GalacticTrade__/graphics/icons/trading-chest-buy.png",
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 1, result = "trading-chest-buy"},
      max_health = 100,
      corpse = "small-remnants",
      open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
      close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
      resistances =
      {
        {
          type = "fire",
          percent = 80
        }
      },
      collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      fast_replaceable_group = "container",
      inventory_size = 48,
      picture =
      {
        filename = "__GalacticTrade__/graphics/trading-chest/trading-chest-buy.png",
        priority = "extra-high",
        width = 38,
        height = 32,
        shift = {0.1, 0}
      }
  },
  {
      type = "container",
      name = "trading-chest-sell",
      icon = "__GalacticTrade__/graphics/icons/trading-chest-sell.png",
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 1, result = "trading-chest-sell"},
      max_health = 100,
      corpse = "small-remnants",
      open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
      close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
      resistances =
      {
        {
          type = "fire",
          percent = 80
        }
      },
      collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      fast_replaceable_group = "container",
      inventory_size = 48,
      picture =
      {
        filename = "__GalacticTrade__/graphics/trading-chest/trading-chest-sell.png",
        priority = "extra-high",
        width = 38,
        height = 32,
        shift = {0.1, 0}
      }
  }
})