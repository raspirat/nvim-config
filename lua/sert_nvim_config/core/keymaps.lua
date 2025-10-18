-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>ewsv", "<C-w>v", { desc = "Split window vertically" })                              -- split window vertically
keymap.set("n", "<leader>ewsh", "<C-w>s", { desc = "Split window horizontally" })                            -- split window horizontally
keymap.set("n", "<leader>ewse", "<C-w>=", { desc = "Make splits equal size" })                               -- make split windows equal width & height
keymap.set("n", "<leader>ewc", "<cmd>close<CR>", { desc = "Close current split" })                           -- close current split window

keymap.set("n", "<leader>etn", "<cmd>tabnew<CR>", { desc = "Open new tab" })                                 -- open new tab
keymap.set("n", "<leader>eto", "<cmd>tabnew<CR>", { desc = "Open new tab" })                                 -- open new tab
keymap.set("n", "<leader>etc", "<cmd>tabclose<CR>", { desc = "Close current tab" })                          -- close current tab
keymap.set("n", "<leader>etl", "<cmd>tabn<CR>", { desc = "Go to next tab" })                                 -- go to next tab
keymap.set("n", "<leader>eth", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                             -- go to previous tab
keymap.set("n", "<leader>etf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })             -- move current buffer to new tab
keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", { desc = "Open current buffer in new tab" }) -- diagnostics list to jump
vim.keymap.set("v", "<M-e>", function() require("dapui").eval() end, { desc = "Eval expression with DAP UI" })

function insertFullPath()
  local filepath = vim.fn.expand('%:p')
  vim.fn.setreg('+', filepath) -- write to clippoard
end

keymap.set('n', '<leader>pc', insertFullPath, { desc = "Copy filepath", noremap = true, silent = true })
