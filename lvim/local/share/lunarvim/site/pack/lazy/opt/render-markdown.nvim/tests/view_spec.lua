---@module 'luassert'

local View = require('render-markdown.request.view')
local mock = require('luassert.mock')

local Env = mock(require('render-markdown.lib.env'), true)
Env.buf.windows.on_call_with(0).returns({ 1000, 1001, 1002, 1003 })
Env.range.on_call_with(0, 1000, 10).returns(0, 10)
Env.range.on_call_with(0, 1001, 10).returns(5, 15)
Env.range.on_call_with(0, 1002, 10).returns(20, 30)
Env.range.on_call_with(0, 1003, 10).returns(35, 45)

describe('view', function()
    it('string', function()
        assert.same('[0->15,20->30,35->45]', tostring(View.new(0)))
    end)
end)
