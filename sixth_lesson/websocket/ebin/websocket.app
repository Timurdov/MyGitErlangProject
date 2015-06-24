%% Feel free to use, reuse and abuse the code in this file.

{application, websocket, [
	{description, "Cowboy websocket example."},
	{vsn, "1"},
	{modules, ['ws_handler', 'websocket_sup', 'websocket_app']},
	{registered, [websocket_sup]},
	{applications, [
		kernel,
		stdlib,
		cowboy
	]},
	{mod, {websocket_app, []}},
	{env, []}
]}.
