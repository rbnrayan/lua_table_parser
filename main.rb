require_relative 'lua_table'

sample = '{
    "ellisonleao/gruvbox.nvim",
    "rebelot/kanagawa.nvim",
    "neovim/nvim-lspconfig",
    "rbnrayan/yello_world.nvim",
    autopairs = { "windwp/nvim-autopairs" }
}'

lua_table = LuaTable.new(sample)
lua_table.add("test")
lua_table.add({ name: "sh" })
p lua_table.table 
