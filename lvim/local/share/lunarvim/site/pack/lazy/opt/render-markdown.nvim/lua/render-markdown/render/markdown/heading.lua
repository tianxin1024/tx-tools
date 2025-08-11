local Base = require('render-markdown.render.base')
local Env = require('render-markdown.lib.env')
local List = require('render-markdown.lib.list')
local Str = require('render-markdown.lib.str')
local colors = require('render-markdown.core.colors')

---@class render.md.heading.Data
---@field atx boolean
---@field marker render.md.Node
---@field level integer
---@field icon? string
---@field sign? string
---@field fg? string
---@field bg? string
---@field width render.md.base.Width
---@field left_margin number
---@field left_pad number
---@field right_pad number
---@field min_width integer
---@field border boolean

---@class render.md.heading.Box
---@field padding integer
---@field body integer
---@field margin integer

---@class render.md.render.Heading: render.md.Render
---@field private config render.md.heading.Config
---@field private data render.md.heading.Data
local Render = setmetatable({}, Base)
Render.__index = Render

---@protected
---@return boolean
function Render:setup()
    self.config = self.context.config.heading
    if self.context:skip(self.config) then
        return false
    end
    if self.context.conceal:hidden(self.node) then
        return false
    end
    local atx, marker, level
    if self.node.type == 'atx_heading' and self.config.atx then
        atx = true
        marker = assert(self.node:child_at(0), 'atx heading missing marker')
        level = Str.level(marker.text)
    elseif self.node.type == 'setext_heading' and self.config.setext then
        atx = false
        marker = assert(self.node:child_at(1), 'ext heading missing underline')
        level = marker.type == 'setext_h1_underline' and 1 or 2
    else
        return false
    end
    local custom = self:custom()
    self.data = {
        atx = atx,
        marker = marker,
        level = level,
        icon = custom.icon or self:get_string(self.config.icons, level),
        sign = List.cycle(self.config.signs, level),
        fg = custom.foreground or List.clamp(self.config.foregrounds, level),
        bg = custom.background or List.clamp(self.config.backgrounds, level),
        width = List.clamp(self.config.width, level) or 'full',
        left_margin = List.clamp(self.config.left_margin, level) or 0,
        left_pad = List.clamp(self.config.left_pad, level) or 0,
        right_pad = List.clamp(self.config.right_pad, level) or 0,
        min_width = List.clamp(self.config.min_width, level) or 0,
        border = List.clamp(self.config.border, level) or false,
    }
    return true
end

---@private
---@return render.md.heading.Custom
function Render:custom()
    for _, custom in pairs(self.config.custom) do
        if self.node.text:find(custom.pattern) then
            return custom
        end
    end
    return {}
end

---@private
---@param values render.md.heading.String
---@param level integer
---@return string?
function Render:get_string(values, level)
    if type(values) == 'function' then
        return values({
            level = level,
            sections = self.node:sections(),
        })
    else
        return List.cycle(values, level)
    end
end

---@protected
function Render:run()
    self:sign(self.config.sign, self.data.sign, self.data.fg)
    local box = self:box(self:marker())
    self:background(box)
    self:padding(box)
    if self.data.atx then
        self:border(box, true)
        self:border(box, false)
    else
        self.marks:over(true, self.data.marker, { conceal = '' })
        self.marks:over(true, self.data.marker, { conceal_lines = '' })
    end
end

---@private
---@return integer
function Render:marker()
    local icon = self.data.icon
    local highlight = {} ---@type string[]
    if self.data.fg then
        highlight[#highlight + 1] = self.data.fg
    end
    if self.data.bg then
        highlight[#highlight + 1] = self.data.bg
    end
    if self.data.atx then
        local node = self.data.marker
        -- add 1 to account for space after last '#'
        local width = self.context:width(node) + 1
        if not icon or #highlight == 0 then
            return width
        end
        if self.config.position == 'right' then
            self.marks:over(true, node, { conceal = '' }, { 0, 0, 0, 1 })
            self.marks:start('head_icon', node, {
                priority = 1000,
                virt_text = { { icon, highlight } },
                virt_text_pos = 'eol',
            })
            return 1 + Str.width(icon)
        else
            local padding = width - Str.width(icon)
            if self.config.position == 'inline' or padding < 0 then
                local added = self.marks:over('head_icon', node, {
                    virt_text = { { icon, highlight } },
                    virt_text_pos = 'inline',
                    conceal = '',
                }, { 0, 0, 0, 1 })
                return added and Str.width(icon) or width
            else
                self.marks:over('head_icon', node, {
                    virt_text = { { Str.pad(padding) .. icon, highlight } },
                    virt_text_pos = 'overlay',
                })
                return width
            end
        end
    else
        local node = self.node
        if not icon or #highlight == 0 then
            return 0
        end
        if self.config.position == 'right' then
            self.marks:start('head_icon', node, {
                priority = 1000,
                virt_text = { { icon, highlight } },
                virt_text_pos = 'eol',
            })
            return 1 + Str.width(icon)
        else
            local added = true
            for row = node.start_row, node.end_row - 1 do
                local start = row == node.start_row
                local text = start and icon or Str.pad(Str.width(icon))
                added = added
                    and self.marks:add('head_icon', row, node.start_col, {
                        virt_text = { { text, highlight } },
                        virt_text_pos = 'inline',
                    })
            end
            return added and Str.width(icon) or 0
        end
    end
end

---@private
---@param marker_width integer
---@return render.md.heading.Box
function Render:box(marker_width)
    local width = marker_width
    if self.data.atx then
        width = width + self.context:width(self.node:child('inline'))
    else
        width = width + vim.fn.max(self.node:widths())
    end
    local left = Env.win.percent(self.context.win, self.data.left_pad, width)
    local right = Env.win.percent(self.context.win, self.data.right_pad, width)
    local body = math.max(left + width + right, self.data.min_width)
    ---@type render.md.heading.Box
    return {
        padding = left,
        body = body,
        margin = Env.win.percent(self.context.win, self.data.left_margin, body),
    }
end

---@private
---@param box render.md.heading.Box
function Render:background(box)
    local highlight = self.data.bg
    if not highlight then
        return
    end
    local padding = self:line()
    local win_col = 0
    if self.data.width == 'block' then
        padding:pad(vim.o.columns * 2)
        win_col = box.margin + box.body + self:indent():size(self.data.level)
    end
    for row = self.node.start_row, self.node.end_row - 1 do
        self.marks:add('head_background', row, self.node.start_col, {
            end_row = row + 1,
            hl_group = highlight,
            hl_eol = true,
        })
        if not padding:empty() and win_col > 0 then
            -- overwrite anything beyond width with padding
            self.marks:add('head_background', row, self.node.start_col, {
                priority = 0,
                virt_text = padding:get(),
                virt_text_win_col = win_col,
            })
        end
    end
end

---@private
---@param box render.md.heading.Box
function Render:padding(box)
    local line = self:line():pad(box.margin)
    line:pad(box.padding, self.data.bg)
    if line:empty() then
        return
    end
    for row = self.node.start_row, self.node.end_row - 1 do
        self.marks:add(false, row, 0, {
            priority = 0,
            virt_text = line:get(),
            virt_text_pos = 'inline',
        })
    end
end

---@private
---@param box render.md.heading.Box
---@param above boolean
function Render:border(box, above)
    if not self.data.border then
        return
    end

    local fg = self.data.fg
    local bg = self.data.bg and colors.bg_as_fg(self.data.bg)
    local prefix = self.config.border_prefix and self.data.level or 0
    local width = self.data.width == 'block' and box.body or vim.o.columns
    local icon = above and self.config.above or self.config.below

    local line = self:line():pad(box.margin)
    line:text(icon:rep(box.padding), bg)
    line:text(icon:rep(prefix), fg)
    line:text(icon:rep(width - box.padding - prefix), bg)

    local virtual = self.config.border_virtual
    local row, target = self.node:line(above and 'above' or 'below', 1)
    local available = target and Str.width(target) == 0

    if not virtual and available and self.context.used:take(row) then
        self.marks:add('head_border', row, 0, {
            virt_text = line:get(),
            virt_text_pos = 'overlay',
        })
    else
        self.marks:add(false, self.node.start_row, 0, {
            virt_lines = {
                self:indent():line(true, self.data.level):extend(line):get(),
            },
            virt_lines_above = above,
        })
    end
end

return Render
