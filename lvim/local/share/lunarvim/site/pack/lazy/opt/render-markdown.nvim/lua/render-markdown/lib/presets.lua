---@enum render.md.config.Preset
local Preset = {
    none = 'none',
    lazy = 'lazy',
    obsidian = 'obsidian',
}

---@class render.md.Presets
local M = {}

---@param user render.md.UserConfig
---@return render.md.UserConfig
function M.get(user)
    local config = M.config(user.preset)
    config.pipe_table = M.pipe_table((user.pipe_table or {}).preset)
    return config
end

---@private
---@param preset? render.md.config.Preset
---@return render.md.UserConfig
function M.config(preset)
    if preset == Preset.obsidian then
        ---@type render.md.UserConfig
        return {
            render_modes = true,
        }
    elseif preset == Preset.lazy then
        ---https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/markdown.lua
        ---@type render.md.UserConfig
        return {
            file_types = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
            code = {
                sign = false,
                width = 'block',
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
            checkbox = {
                enabled = false,
            },
        }
    else
        ---@type render.md.UserConfig
        return {}
    end
end

---@private
---@param preset? render.md.table.Preset
---@return render.md.table.UserConfig
function M.pipe_table(preset)
    if preset == 'round' then
        ---@type render.md.table.UserConfig
        return {
            -- stylua: ignore
            border = {
                '╭', '┬', '╮',
                '├', '┼', '┤',
                '╰', '┴', '╯',
                '│', '─',
            },
        }
    elseif preset == 'double' then
        ---@type render.md.table.UserConfig
        return {
            -- stylua: ignore
            border = {
                '╔', '╦', '╗',
                '╠', '╬', '╣',
                '╚', '╩', '╝',
                '║', '═',
            },
        }
    elseif preset == 'heavy' then
        ---@type render.md.table.UserConfig
        return {
            alignment_indicator = '─',
            -- stylua: ignore
            border = {
                '┏', '┳', '┓',
                '┣', '╋', '┫',
                '┗', '┻', '┛',
                '┃', '━',
            },
        }
    else
        ---@type render.md.table.UserConfig
        return {}
    end
end

return M
