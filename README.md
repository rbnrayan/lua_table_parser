# Lua Table Parser

**WIP**: realy simple lua table parser

Example:

```ruby
require_relative 'lua_table'

# the lua table
sample = '{ name = "sh" }'

# tokenization + parsing of the lua table
lua_table = LuaTable.new(sample)
# adding an entry to the table
lua_table.add({ cmd: "/bin/sh" })

p lua_table.table
```
