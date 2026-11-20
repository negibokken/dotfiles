return {
  "numToStr/Comment.nvim",
  -- Preserve line and block operators, including gbc/gco/gcO/gcA.
  keys = {
    { "gc", mode = { "n", "x" } },
    { "gb", mode = { "n", "x" } },
    { "gcc" },
    { "gbc" },
    { "gco" },
    { "gcO" },
    { "gcA" },
  },
  opts = {},
}
