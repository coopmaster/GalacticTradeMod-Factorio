data.raw["gui-style"].default["blank".."_gt_button_style"]  =
{
  type = "checkbox_style",
  parent = "checkbox_style",
  width = 38,
  height = 45,
  hovered_background =
  {
    filename = "__core__/graphics/gui.png",
    priority = "extra-high-no-scale",
    width = 35,
    height = 35,
    x = 185,
    y = 0
  },
  default_background =
  {
    filename = "__core__/graphics/gui.png",
    priority = "extra-high-no-scale",
    width = 35,
    height = 35,
    x = 185,
    y = 0
  },
  checked =
  {
    filename = "__core__/graphics/gui.png",
    priority = "extra-high-no-scale",
    width = 35,
    height = 35,
    x = 185,
    y = 0
  },
  clicked_background =
  {
    filename = "__core__/graphics/gui.png",
    priority = "extra-high-no-scale",
    width = 35,
    height = 35,
    x = 111,
    y = 0
  }
}

for a, b in pairs(data.raw) do
  for name, item in pairs(b) do
    if item.stack_size then
      data.raw["gui-style"].default[name.."_gt_button_style"]  =
      {
        type = "checkbox_style",
        parent = "checkbox_style",
        width = 38,
        height = 45,
        hovered_background =
        {
          filename = item.icon,
          priority = "extra-high-no-scale",
          width = 32,
          height = 32,
          x = 0,
          y = 0
        },
        default_background =
        {
          filename = item.icon,
          priority = "extra-high-no-scale",
          width = 32,
          height = 32,
          x = 0,
          y = 0
        },
        checked =
        {
          filename = "__core__/graphics/gui.png",
          priority = "extra-high-no-scale",
          width = 0,
          height = 0
        },
        clicked_background =
        {
          filename = "__core__/graphics/gui.png",
          priority = "extra-high-no-scale",
          width = 35,
          height = 35,
          x = 111
        }
      }
    end
  end
end

