-- Auto mkdir
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- ESKK Settings
vim.g["eskk#no_default_mappings"] = 1
local eskk_base_dir = vim.fn.stdpath("data") .. "/eskk"
local jisyo = eskk_base_dir .. "/.skk-jisyo"
local large_jisyo = eskk_base_dir .. "/SKK-JISYO.L"
vim.g["eskk#directory"] = eskk_base_dir
vim.g["eskk#dictionary"] = jisyo
vim.g["eskk#large_dictionary"] = {
	path = large_jisyo,
	sorted = 1,
	encoding = "euc-jp",
}
vim.g["eskk#egg_like_newline"] = 1
vim.g["eskk#statusline_mode_strings"] = {
	hira = "--かな:",
	kata = "--カナ:",
	ascii = "--SKK::",
	zenei = "--全英:",
	hankata = "--ｶﾀｶﾅ:",
	abbrev = "--aあ::",
}
vim.api.nvim_create_autocmd("User", {
	pattern = "eskk-enable-post",
	callback = function(args)
		vim.keymap.set("l", "l", "<Plug>(eskk:disable)", { buffer = args.buf })
		vim.keymap.set("l", "zl", "→", { buffer = args.buf })
	end,
})

-- Don't nest neovim
vim.env.EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
vim.env.MANPAGER = nil
