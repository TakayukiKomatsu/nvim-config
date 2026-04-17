-- nvim-surround v4: `keymaps` opts are deprecated; bind via <Plug> in keys spec.
-- See `:h nvim-surround.migrating.v3_to_v4`.
return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "gs", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround selection" },
  },
  opts = {},
}
