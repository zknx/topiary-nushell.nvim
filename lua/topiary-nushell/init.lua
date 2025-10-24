local M = {}

M.config = {
  add_formatter_to_conform = true,
}

local function get_data_path()
  return vim.fn.stdpath("data") .. "/topiary-nushell"
end

local function setup_environment()
  local data_path = get_data_path()
  vim.env.TOPIARY_CONFIG_FILE = data_path .. "/languages.ncl"
  vim.env.TOPIARY_LANGUAGE_DIR = data_path .. "/languages"
end

local function clone_topiary_nushell()
  local data_path = get_data_path()

  if vim.fn.isdirectory(data_path) == 1 then
    return true
  end

  vim.notify("Cloning topiary-nushell...", vim.log.levels.INFO)

  local cmd = { "git", "clone", "https://github.com/blindFS/topiary-nushell.git", data_path }

  vim.system(cmd, {}, function(out)
    vim.schedule(
      function()
        if out.code == 0 then
          vim.notify("Successfully cloned topiary-nushell", vim.log.levels.INFO)
          setup_environment()
        else
          vim.notify("Failed to clone topiary-nushell", vim.log.levels.ERROR)
        end
      end)
  end)
end

local function setup_conform()
  local conform = require("conform")
  conform.formatters_by_ft.nu = { "topiary_nu" }
  conform.formatters.topiary_nu = {
    command = "topiary",
    args = { "format", "--language", "nu" },
  }
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  local data_path = get_data_path()

  if vim.fn.isdirectory(data_path) == 0 then
    clone_topiary_nushell()
  end
  setup_environment()
  if (M.config.add_formatter_to_conform) then
    setup_conform()
  end

  vim.api.nvim_create_user_command("TopiaryNuUpdate", function()
    if vim.fn.isdirectory(data_path) == 1 then
      vim.system({ "git", "pull" }, { cwd = data_path }, function(out)
        vim.schedule(function()
          if out.code == 0 then
            vim.notify("Successfully updated topiary-nushell", vim.log.levels.INFO)
          else
            vim.notify("Failed to `git pull` topiary-nushell\n" .. out.stderr, vim.log.levels.ERROR)
          end
        end)
      end)
    end
  end, {})
end

return M
