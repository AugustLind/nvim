-- Adapt legacy nvim-treesitter single-node callbacks to Neovim 0.12 capture lists.
local M = {}
function M.setup()
  if vim.fn.has('nvim-0.12') == 0 then return end
  local file = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/query_predicates.lua', false)[1]
  if not file then return end
  local query = vim.treesitter.query
  local original = { add_predicate = query.add_predicate, add_directive = query.add_directive }
  for name, register in pairs(original) do
    query[name] = function(key, handler, opts)
      if type(opts) == 'table' and opts.all == false then
        local legacy_handler = handler
        handler = function(captures, ...)
          local single = {}
          for id, nodes in pairs(captures) do
            single[id] = type(nodes) == 'table' and nodes[#nodes] or nodes
          end
          return legacy_handler(single, ...)
        end
      end
      return register(key, handler, opts)
    end
  end
  local ok, err = pcall(dofile, file)
  for name, register in pairs(original) do query[name] = register end
  if not ok then error(err) end
end
return M
