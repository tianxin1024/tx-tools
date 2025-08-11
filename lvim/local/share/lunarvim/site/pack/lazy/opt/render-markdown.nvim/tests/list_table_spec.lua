---@module 'luassert'

local util = require('tests.util')

describe('list_table.md', function()
    it('default', function()
        util.setup.file('demo/list_table.md')

        local marks, row = util.marks(), util.row()

        marks:add(row:get(), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        marks:add(row:inc(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), nil, 20, nil, util.link('web'))
        marks:add(row:inc(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), row:get(), 20, 28, util.highlight('code'))
        marks:add(row:inc(), row:get(), 2, 6, util.bullet(2, 2))
        marks:add(row:inc(), row:get(), 4, 6, util.bullet(2))
        marks:add(row:inc(), row:get(), 6, 8, util.bullet(3))
        marks:add(row:inc(), row:get(), 8, 10, util.bullet(4))
        marks:add(row:inc(), row:get(), 10, 12, util.bullet(1))
        marks:add(row:inc(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), nil, 20, nil, util.link('link'))

        marks:add(row:inc(2), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        marks:add(row:inc(), row:get(), 0, 3, {
            virt_text = { { '1.', 'RmBullet' } },
            virt_text_pos = 'overlay',
        })
        marks:add(row:inc(), row:get(), 0, 3, {
            virt_text = { { '2.', 'RmBullet' } },
            virt_text_pos = 'overlay',
        })

        marks:add(row:inc(2), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        local sections = {
            util.table.border(false, true, { 8, 15, 7, 6 }),
            util.table.delimiter({ { 1, 7 }, { 1, 13, 1 }, { 6, 1 }, { 6 } }),
            util.table.border(false, false, { 8, 15, 7, 6 }),
        }
        marks:add(row:get(), nil, 0, nil, sections[1])
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(true))
        marks:add(row:get(), row:get(), 2, 8, util.highlight('code'))
        marks:add(row:get(), nil, 9, nil, util.table.padding(2))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(true))
        marks:add(row:get(), nil, 11, nil, util.table.padding(3))
        marks:add(row:get(), row:get(), 24, 25, util.conceal())
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(true))
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(true))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(true))
        marks:add(row:inc(), row:get(), 0, 41, sections[2])
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(false))
        marks:add(row:get(), row:get(), 2, 8, util.highlight('code'))
        marks:add(row:get(), nil, 9, nil, util.table.padding(2))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(false))
        marks:add(row:get(), nil, 11, nil, util.table.padding(4))
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(false))
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(false))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(false))
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(false))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(false))
        marks:add(row:get(), nil, 11, nil, util.table.padding(3))
        marks:add(row:get(), nil, 11, nil, util.link('link'))
        marks:add(row:get(), nil, 25, nil, util.table.padding(4))
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(false))
        marks:add(row:get(), nil, 27, nil, util.table.padding(1))
        marks:add(row:get(), row:get(), 32, 33, util.conceal())
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(false))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(false))
        marks:add(row:inc(), nil, 0, nil, sections[3])

        util.assert_view(marks, {
            '󰫎 󰲡 Unordered List',
            '',
            '  ● List Item 1: with 󰖟 link',
            '  ● List Item 2: with inline code',
            '      ○ Nested List 1 Item 1',
            '      ○ Nested List 1 Item 2',
            '        ◆ Nested List 2 Item 1',
            '          ◇ Nested List 3 Item 1',
            '            ● Nested List 4 Item 1',
            '  ● List Item 3: with 󰌹 reference link',
            '',
            '󰫎 󰲡 Ordered List',
            '',
            '  1. Item 1',
            '  2. Item 2',
            '',
            '󰫎 󰲡 Table',
            '  ┌────────┬───────────────┬───────┬──────┐',
            '  │ Left   │    Center     │ Right │ None │',
            '  ├━───────┼━─────────────━┼──────━┼──────┤',
            '  │ Code   │     Bold      │ Plain │ Item │',
            '  │ Item   │    󰌹 link     │  Item │ Item │',
            '  └────────┴───────────────┴───────┴──────┘',
            '  [example]: https://example.com',
        })
    end)

    it('padding', function()
        util.setup.file('demo/list_table.md', {
            code = { inline_pad = 2 },
            bullet = { left_pad = 2, right_pad = 2 },
        })

        local marks, row = util.marks(), util.row()

        marks:add(row:get(), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), nil, 1, nil, util.padding(2, 0))
        marks:add(row:get(), nil, 20, nil, util.link('web'))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), nil, 1, nil, util.padding(2, 0))
        marks:add(row:get(), nil, 20, nil, util.code.padding(2))
        marks:add(row:get(), row:get(), 20, 28, util.highlight('code'))
        marks:add(row:get(), nil, 28, nil, util.code.padding(2))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 2, 6, util.bullet(2, 2))
        marks:add(row:get(), nil, 5, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 4, 6, util.bullet(2))
        marks:add(row:get(), nil, 5, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 6, 8, util.bullet(3))
        marks:add(row:get(), nil, 7, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 8, 10, util.bullet(4))
        marks:add(row:get(), nil, 9, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 10, 12, util.bullet(1))
        marks:add(row:get(), nil, 11, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 0, 2, util.bullet(1))
        marks:add(row:get(), nil, 1, nil, util.padding(2, 0))
        marks:add(row:get(), nil, 20, nil, util.link('link'))

        marks:add(row:inc(2), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 0, 3, {
            virt_text = { { '1.', 'RmBullet' } },
            virt_text_pos = 'overlay',
        })
        marks:add(row:get(), nil, 2, nil, util.padding(2, 0))
        marks:add(row:inc(), nil, 0, nil, util.padding(2, 0))
        marks:add(row:get(), row:get(), 0, 3, {
            virt_text = { { '2.', 'RmBullet' } },
            virt_text_pos = 'overlay',
        })
        marks:add(row:get(), nil, 2, nil, util.padding(2, 0))

        marks:add(row:inc(2), nil, 0, nil, util.heading.sign(1))
        marks:add(row:get(), row:get(), 0, 1, util.heading.icon(1))
        marks:add(row:get(), row:inc(), 0, 0, util.heading.bg(1))

        local sections = {
            util.table.border(false, true, { 10, 15, 7, 6 }),
            util.table.delimiter({ { 1, 9 }, { 1, 13, 1 }, { 6, 1 }, { 6 } }),
            util.table.border(false, false, { 10, 15, 7, 6 }),
        }
        marks:add(row:get(), nil, 0, nil, sections[1])
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(true))
        marks:add(row:get(), nil, 2, nil, util.code.padding(2))
        marks:add(row:get(), row:get(), 2, 8, util.highlight('code'))
        marks:add(row:get(), nil, 8, nil, util.code.padding(2))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(true))
        marks:add(row:get(), nil, 11, nil, util.table.padding(3))
        marks:add(row:get(), row:get(), 24, 25, util.conceal())
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(true))
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(true))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(true))
        marks:add(row:inc(), row:get(), 0, 41, sections[2])
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(false))
        marks:add(row:get(), nil, 2, nil, util.code.padding(2))
        marks:add(row:get(), row:get(), 2, 8, util.highlight('code'))
        marks:add(row:get(), nil, 8, nil, util.code.padding(2))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(false))
        marks:add(row:get(), nil, 11, nil, util.table.padding(4))
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(false))
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(false))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(false))
        marks:add(row:inc(), row:get(), 0, 1, util.table.pipe(false))
        marks:add(row:get(), nil, 9, nil, util.table.padding(2))
        marks:add(row:get(), row:get(), 9, 10, util.table.pipe(false))
        marks:add(row:get(), nil, 11, nil, util.table.padding(3))
        marks:add(row:get(), nil, 11, nil, util.link('link'))
        marks:add(row:get(), nil, 25, nil, util.table.padding(4))
        marks:add(row:get(), row:get(), 25, 26, util.table.pipe(false))
        marks:add(row:get(), nil, 27, nil, util.table.padding(1))
        marks:add(row:get(), row:get(), 32, 33, util.conceal())
        marks:add(row:get(), row:get(), 33, 34, util.table.pipe(false))
        marks:add(row:get(), row:get(), 40, 41, util.table.pipe(false))
        marks:add(row:inc(), nil, 0, nil, sections[3])

        util.assert_view(marks, {
            '󰫎 󰲡 Unordered List',
            '',
            '    ●   List Item 1: with 󰖟 link',
            '    ●   List Item 2: with   inline   code',
            '        ○   Nested List 1 Item 1',
            '        ○   Nested List 1 Item 2',
            '          ◆   Nested List 2 Item 1',
            '            ◇   Nested List 3 Item 1',
            '              ●   Nested List 4 Item 1',
            '    ●   List Item 3: with 󰌹 reference link',
            '',
            '󰫎 󰲡 Ordered List',
            '',
            '    1.   Item 1',
            '    2.   Item 2',
            '',
            '󰫎 󰲡 Table',
            '  ┌──────────┬───────────────┬───────┬──────┐',
            '  │   Left   │    Center     │ Right │ None │',
            '  ├━─────────┼━─────────────━┼──────━┼──────┤',
            '  │   Code   │     Bold      │ Plain │ Item │',
            '  │ Item     │    󰌹 link     │  Item │ Item │',
            '  └──────────┴───────────────┴───────┴──────┘',
            '  [example]: https://example.com',
        })
    end)
end)
