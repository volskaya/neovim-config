local M = {}

local telescope_utilities = require("telescope.utils")
local telescope_make_entry_module = require("telescope.make_entry")
-- local plenary_strings = require("plenary.strings")
-- local dev_icons = require("nvim-web-devicons")
local telescope_entry_display_module = require("telescope.pickers.entry_display")

-- local file_type_icon_width = plenary_strings.strdisplaywidth(dev_icons.get_icon("fname", { default = true }))

function M.get_path_and_tail(file_name)
  local buffer_name_tail = telescope_utilities.path_tail(file_name) ---@type string
  local path_without_tail = require("plenary.strings").truncate(file_name, #file_name - #buffer_name_tail, "")

  local tail_slices = vim.split(path_without_tail, "/")
  local tail_last_items = {}

  for i = 0, math.max(#tail_slices - 1, 2), 1 do
    local item = tail_slices[#tail_slices - i]
    table.insert(tail_last_items, item)
  end

  local tail = table.concat(tail_last_items, "/")
  return buffer_name_tail, tail
end

function M.pretty_files_picker(opts)
  -- TODO: Move this to utilities. This thing shows path in the title.
  -- TODO: Maybe remove, been enjoying OIL a lot more and not using this anymore.
  local telescope = require("telescope")
  local custom_browser = telescope.extensions.file_browser
  local fb_utils = require("telescope._extensions.file_browser.utils")
  local redraw_border_title = fb_utils.redraw_border_title
  fb_utils.redraw_border_title = function(current_picker)
    local Path = require("plenary.path")
    local finder = current_picker.finder
    if current_picker.prompt_border then
      local parent = Path:new(finder.cwd):parent().filename
      local new_title = Path:new(finder.path):make_relative(parent)
      if parent == finder.path then
        new_title = parent
      end
      current_picker.prompt_border:change_title(new_title)
    end
    redraw_border_title(current_picker)
  end

  local picker = custom_browser.file_browser
  custom_browser.file_browser = function(opts)
    local Path = require("plenary.path")
    local parent = Path:new(opts.cwd):parent().filename
    opts.prompt_title = Path:new(opts.path):make_relative(parent)
    picker(opts)
  end

  custom_browser.file_browser(opts)
end

function M.pretty_grep_picker(picker_and_options)
  if type(picker_and_options) ~= "table" or picker_and_options.picker == nil then
    print("Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }")

    return
  end

  options = picker_and_options.options or {}

  local original_entry_maker = telescope_make_entry_module.gen_from_vimgrep(options)

  options.entry_maker = function(line)
    local state = require("telescope.state")
    local status = state.get_status(vim.api.nvim_get_current_buf())
    local window_width = vim.api.nvim_win_get_width(status.layout.results.winid)

    local original_entry_table = original_entry_maker(line)
    local file_name_length_max = 20
    local displayer = telescope_entry_display_module.create({
      separator = " ", -- Telescope will use this separator between each entry item
      seprator_hl = false,
      hl_chars = { false, false, false, false },
      items = {
        -- { width = file_type_icon_width },
        { width = window_width - file_name_length_max - 3 },
        { width = file_name_length_max },
        -- { width = nil }, -- Maximum path size, keep it short
        -- { width = nil },
        -- { remaining = true },
        -- { remaining = false },
      },
    })

    original_entry_table.display = function(entry)
      local tail, path_to_display = M.get_path_and_tail(entry.filename)
      local icon, icon_highlight = telescope_utilities.get_devicons(tail)
      local coordinates = ""

      if not options.disable_coordinates then
        if entry.lnum then
          if entry.col then
            coordinates = string.format(" -> %s:%s", entry.lnum, entry.col)
          else
            coordinates = string.format(" -> %s", entry.lnum)
          end
        end
      end

      tail = tail .. coordinates

      local tail_for_display = tail .. " "
      local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text

      return displayer({
        -- { icon, icon_highlight },
        -- { "" },
        -- { tail_for_display, "TelescopeResultsComment" },
        -- { path_to_display, "TelescopeResultsComment" },
        text,
        { tail, "TelescopeResultsComment" },
      })
    end

    return original_entry_table
  end

  -- Finally, check which file picker was requested and open it with its associated options
  if picker_and_options.picker == "live_grep" then
    require("telescope.builtin").live_grep(options)
  elseif picker_and_options.picker == "grep_string" then
    require("telescope.builtin").grep_string(options)
  elseif picker_and_options.picker == "" then
    print("Picker was not specified")
  else
    print("Picker is not supported by Pretty Grep Picker")
  end
end

return M
