local util = require("trouble.util")

---@class Lsp
local M = {}

---@param options TroubleOptions
---@return Item[]
function M.diagnostics(_, buf, cb, options)
    -- print("Options:" .. vim.inspect(options))
    if options.mode == "workspace_diagnostics" then
        buf = nil
    end

    local items = {}
    local diags = vim.diagnostic.get(buf, { severity = { min = options.cmd_options.severity } })
    for _, item in ipairs(diags) do
        table.insert(items, util.process_item(item))
    end

    cb(items)
end

function M.get_signs()
    local signs = {}
    for _, v in pairs(util.severity) do
        if v ~= "Other" then
            -- pcall to catch entirely unbound or cleared out sign hl group
            local status, sign = pcall(function()
                return vim.trim(vim.fn.sign_getdefined(util.get_severity_label(v, "Sign"))[1].text)
            end)
            if not status then
                sign = v:sub(1, 1)
            end
            signs[string.lower(v)] = sign
        end
    end
    return signs
end

return M
