data:extend({

 {
    type = "item",
    name = "trading-chest-buy",
    icon = "__GalacticTrade__/graphics/icons/trading-chest-buy.png",
    flags = { "goes-to-quickbar" },
    subgroup = "storage",
    order = "a[items]-b[trading-chest-buy]",
    place_result="trading-chest-buy",
    stack_size= 50,
  },
  {
    type = "item",
    name = "trading-chest-sell",
    icon = "__GalacticTrade__/graphics/icons/trading-chest-sell.png",
    flags = { "goes-to-quickbar" },
    subgroup = "storage",
    order = "a[items]-b[strading-chest-sell]",
    place_result="trading-chest-sell",
    stack_size= 50,
  }

})