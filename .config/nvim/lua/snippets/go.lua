require('luasnip.session.snippet_collection').clear_snippets('go')
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

---@param abbr string
---@param expansion string
---@param args table
local function snip(abbr, expansion, args)
    return ls.snippet(abbr, require('luasnip.extras.fmt').fmt(expansion, args))
end

local tea_model = [=[
import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
)

type Model struct{{
    {}
}}

func New() Model {{
	return Model{{
    }}
}}

func (m Model) Init() tea.Cmd {{
	return nil
}}

func (m Model) View() string {{
	return fmt.Sprintf(
		"%s",
		"",
	)
}}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {{
	switch msg := msg.(type) {{
	default:
		return m, nil
	}}
}}
]=]

local server_api = [=[
func {}(ctx context.Context, sess *session.Session, request packet{}) packet.Payload {{
}}
]=]

ls.add_snippets('go', {
    snip('tmod', tea_model, { i(0) }),
    snip('sapi', server_api, { i(1), i(0) }),

    s('iferr', {
        t({ 'if err != nil {', '' }),
        i(1, '    return'),
        t({ '', '}' }),
    }),

    s('fmterr', {
        t('fmt.Errorf("'),
        i(1, 'msg'),
        t(': %w", err)'),
    }),

    s('dberr', {
        t({ 'if err != nil {', '' }),
        i(2, { '    log.Println("database error ', 'x', ':", err)', '' }),
        i(2, '    return ', '&ErrInternalError'),
        t({ '', '}' }),
    }),
})
