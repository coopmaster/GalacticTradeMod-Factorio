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
  },
  {
      type = "technology",
      name = "logistictradingtech",
      icon = "__GalacticTrade__/graphics/icons/logistic-trading-chest-buy.png",
      effects =
      {
        {
            type = "unlock-recipe",
            recipe = "logistic-trading-chest-buy"
        },
        {
            type = "unlock-recipe",
            recipe = "logistic-trading-chest-sell"
        }
      },
      prerequisites = {"logistic-system"},
      unit =
      {
        count = 150,
        ingredients = {
          {"science-pack-1", 1},
          {"science-pack-2", 1},
          {"science-pack-3", 1}
        },
        time = 30
      },
      order = "c-k-d",
  },
  {
    type = "technology",
    name = "tradingefficiency1",
    icon = "__GalacticTrade__/graphics/icons/moneysign.png",
    effects ={
    },
    prerequisites = {
      "tradingtech"
    },
    unit = {
      count = 50,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 30
    },
    upgrade = true,
    order = "g-t-a-a"
  },
  {
    type = "technology",
    name = "tradingefficiency2",
    icon = "__GalacticTrade__/graphics/icons/moneysign.png",
    effects ={
    },
    prerequisites = {
      "tradingefficiency1"
    },
    unit = {
      count = 150,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 30
    },
    upgrade = true,
    order = "g-t-a-b"
  },
  {
    type = "technology",
    name = "tradingefficiency3",
    icon = "__GalacticTrade__/graphics/icons/moneysign.png",
    effects ={
    },
    prerequisites = {
      "tradingefficiency2"
    },
    unit = {
      count = 350,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 30
    },
    upgrade = true,
    order = "g-t-a-c"
  }
})