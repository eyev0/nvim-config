local fidget = require("fidget")

fidget.setup({
	text = {
		commenced = "Start", -- message shown when task starts
		completed = "Done", -- message shown when task completes
	},
	window = {
		relative = "editor",
		blend = 0,
	},
	timer = {
		fidget_decay = 1300, -- how long to keep around empty fidget, in ms
		task_decay = 1000, -- how long to keep around completed task, in ms
	},
	fmt = {
		stack_upwards = true, -- list of tasks grows upwards
		max_width = 38, -- maximum width of the fidget box
	},
	sources = {
		["null-ls"] = {
			ignore = true,
		},
	},
})
