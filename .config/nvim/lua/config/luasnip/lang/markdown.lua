local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local f = luasnip.function_node

local function bash(_, _, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end

-- stylua: ignore start
return {
    s("pwd", f(bash, {}, "pwd")),
    s("ls", f(bash, {}, "ls")),
    s("lsa", f(bash, {}, "ls -A")),
    s("date", f(bash, {}, "date '+%Y-%m-%d'")),
    s("datetime", f(bash, {}, "date '+%Y-%m-%d %H:%M:%S'")),
    s("time", f(bash, {}, "date '+%H:%M:%S'")),

    s("forall", t("∀")),
    s("exists", t("∃")),
    s("in", t("∈")),
    s("notin", t("∉")),
    s("subset", t("⊆")),
    s("subsetnoteq", t("⊂")),
    s("intersect", t("∩")),
    s("union", t("∪")),
    s("setmin", t("∖")),

    s("land", t("∧")),
    s("lor", t("∨")),
    s("xor", t("⊻")),
}
-- stylua: ignore end
