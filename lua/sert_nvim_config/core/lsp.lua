local vim = vim
local keymap = vim.keymap

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

    keymap.set("n", "<leader>lme", ":RustLsp expandMacro<CR>", { desc = "Expand rust macro under cursor" })
  end,
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
});

-- vim.lsp.config('ltex_plus', {
--   on_attach = function(client, bufnr)
--     local job_var = "latexmk_job_id"
--     vim.api.nvim_create_autocmd("BufWritePost", {
--       buffer = bufnr,
--       callback = function()
--         local fname = vim.api.nvim_buf_get_name(bufnr)
--         if fname == "" then return end
--
--         -- Check if file is a LaTeX file
--         local extension = vim.fn.fnamemodify(fname, ":e")
--         if extension ~= "tex" then return end
--
--         local cwd = vim.fn.fnamemodify(fname, ":p:h")
--         local basename = vim.fn.fnamemodify(fname, ":t")
--
--         local function subtle(msg)
--           vim.notify(msg, vim.log.levels.INFO, { timeout = 1200 })
--         end
--
--         -- stop previous job if still running
--         local prev = vim.b[bufnr][job_var]
--         if prev and vim.fn.jobwait({ prev }, 0)[1] == -1 then
--           pcall(vim.fn.jobstop, prev)
--           vim.b[bufnr][job_var] = nil
--         end
--
--         local stdout, stderr = {}, {}
--         local jid = vim.fn.jobstart({
--           "latexmk", "-pdf", "-interaction=nonstopmode", "-synctex=1", basename
--         }, {
--           cwd = cwd,
--           stdout_buffered = true,
--           stderr_buffered = true,
--           on_stdout = function(_, data)
--             if data then
--               for _, line in ipairs(data) do if line ~= "" then table.insert(stdout, line) end end
--             end
--           end,
--           on_stderr = function(_, data)
--             if data then
--               for _, line in ipairs(data) do if line ~= "" then table.insert(stderr, line) end end
--             end
--           end,
--           on_exit = function(_, code)
--             -- schedule UI work to avoid doing it in job thread
--             vim.schedule(function()
--               vim.b[bufnr][job_var] = nil
--               if code == 0 then
--                 subtle("latexmk: build succeeded")
--               else
--                 subtle("latexmk: build failed (see :LatexmkOutput)")
--                 -- create/read output buffer
--                 local out = { "=== latexmk stdout ===" }
--                 vim.list_extend(out, stdout)
--                 vim.list_extend(out, { "", "=== latexmk stderr ===" })
--                 vim.list_extend(out, stderr)
--                 local outbuf = vim.api.nvim_create_buf(false, true)
--                 vim.api.nvim_buf_set_lines(outbuf, 0, -1, false, out)
--                 vim.api.nvim_buf_set_option(outbuf, "filetype", "log")
--                 vim.api.nvim_buf_set_option(outbuf, "bufhidden", "wipe")
--                 -- store buffer id and command to open it
--                 vim.b[bufnr].latexmk_output_buf = outbuf
--                 -- create a buffer-local command to open the log (idempotent)
--                 pcall(vim.api.nvim_buf_create_user_command, bufnr, "LatexmkOutput", function()
--                   if vim.api.nvim_buf_is_valid(outbuf) then vim.api.nvim_set_current_buf(outbuf) end
--                 end, { desc = "Show latexmk output" })
--               end
--             end)
--           end,
--         })
--
--         if jid and jid > 0 then
--           vim.b[bufnr][job_var] = jid
--         else
--           subtle("latexmk: failed to start")
--         end
--       end,
--       desc = "Autocompile LaTeX with latexmk on save (ltex attach, subtle notify)",
--     })
--   end,
-- });
