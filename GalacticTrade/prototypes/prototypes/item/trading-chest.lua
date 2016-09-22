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
  },
  {
    type = "item",
    name = "logistic-trading-chest-buy",
    icon = "__GalacticTrade__/graphics/icons/logistic-trading-chest-buy.png",
    flags = { "goes-to-quickbar" },
    subgroup = "logistic-network",
    order = "b[storage]-c[logistic-trading-chest-buy]",
    place_result="logistic-trading-chest-buy",
    stack_size= 50,
  },
  {
    type = "item",
    name = "logistic-trading-chest-sell",
    icon = "__GalacticTrade__/graphics/icons/logistic-trading-chest-sell.png",
    flags = { "goes-to-quickbar" },
    subgroup = "logistic-network",
    order = "b[storage]-c[logistic-trading-chest-sell]",
    place_result="logistic-trading-chest-sell",
    stack_size= 50,
  }

})