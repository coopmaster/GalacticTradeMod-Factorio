data:extend({
  {
      type = "technology",
      name = "tradingtech",
      icon = "__GalacticTrade__/graphics/icons/trading-chest-buy.png",
      effects =
      {
        {
            type = "unlock-recipe",
            recipe = "trading-chest-buy"
        },
        {
            type = "unlock-recipe",
            recipe = "trading-chest-sell"
        }
      },
      prerequisites = {"electronics"},
      unit =
      {
        count = 50,
        ingredients =
        {
          {"science-pack-1", 2},
          {"science-pack-2", 1}
        },
        time = 15
      }
  }
})