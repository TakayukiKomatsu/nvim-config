local api = vim.api
local M = {}

local ns = nil
local level = 0.46
local excluded_ft = { NvimTree = true }
local excluded_bt = { nofile = true, prompt = true, terminal = true }

local function darken(n)
	if not n then return nil end
	local r = math.floor((math.floor(n / 65536) % 256) * level + 0.5)
	local g = math.floor((math.floor(n / 256) % 256) * level + 0.5)
	local b = math.floor((n % 256) * level + 0.5)
	return r * 65536 + g * 256 + b
end

local function populate_ns()
	if not ns then return end
	local hls = api.nvim_get_hl(0, {})
	for name, def in pairs(hls) do
		if not def.link then
			local new = vim.deepcopy(def)
			if name ~= "VertSplit" and name ~= "WinSeparator" then
				new.fg = darken(new.fg)
				new.bg = darken(new.bg)
				new.sp = darken(new.sp)
			end
			api.nvim_set_hl(ns, name, new)
		end
	end
end

local function is_excluded(bufnr)
	local ft = vim.bo[bufnr].filetype
	local bt = vim.bo[bufnr].buftype
	return excluded_ft[ft]
		or excluded_bt[bt]
		or vim.tbl_contains(excluded_ft, ft)
		or vim.tbl_contains(excluded_bt, bt)
end

local wins_dimmed = {}

local function dim_wins(event)
	if is_excluded(0) then
		if event == "WinClosed" then
			local id = next(wins_dimmed)
			if id then
				if api.nvim_win_is_valid(id) then
					api.nvim_win_set_hl_ns(id, 0)
				end
				wins_dimmed[id] = nil
			end
		end
		return
	end

	local curr = api.nvim_get_current_win()
	for _, win in ipairs(api.nvim_list_wins()) do
		if win ~= curr and not is_excluded(api.nvim_win_get_buf(win)) then
			wins_dimmed[win] = true
			api.nvim_win_set_hl_ns(win, ns)
		end
	end
	wins_dimmed[curr] = nil
	api.nvim_win_set_hl_ns(curr, 0)
end

local function populate_and_apply()
	populate_ns()
	dim_wins(nil)
end

function M.setup(opts)
	opts = opts or {}
	level = opts.level or level
	if opts.excluded_filetypes then excluded_ft = opts.excluded_filetypes end
	if opts.excluded_buftypes then excluded_bt = opts.excluded_buftypes end

	ns = api.nvim_create_namespace("dim_inactive")

	local group = api.nvim_create_augroup("DimInactive", { clear = true })

	-- Witch loads highlights async in batches and fires this after each module
	api.nvim_create_autocmd("User", {
		pattern = "WitchHighlightDone",
		group = group,
		callback = populate_and_apply,
	})

	-- Fallback for non-witch colorschemes
	api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = populate_and_apply,
	})

	api.nvim_create_autocmd({ "WinEnter", "WinClosed" }, {
		group = group,
		callback = function(args)
			if args.event == "WinClosed" then
				wins_dimmed[api.nvim_get_current_win()] = nil
			end
			vim.defer_fn(function() dim_wins(args.event) end, 10)
		end,
	})
end

return M
