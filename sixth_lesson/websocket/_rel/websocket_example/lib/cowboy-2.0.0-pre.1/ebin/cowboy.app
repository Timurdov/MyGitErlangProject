{application,cowboy,
             [{description,"Small, fast, modular HTTP server."},
              {vsn,"2.0.0-pre.1"},
              {id, "2.0.0-pre.2-1-g341f991-dirty"},
              {modules, ['cowboy', 'cowboy_router', 'cowboy_req', 'cowboy_sup', 'cowboy_spdy', 'cowboy_static', 'cowboy_websocket', 'cowboy_app', 'cowboy_stream', 'cowboy_http2', 'cowboy_clock', 'cowboy_handler', 'cowboy_rest', 'cowboy_loop', 'cowboy_sub_protocol', 'cowboy_bstr', 'cowboy_protocol', 'cowboy_tls', 'cowboy_constraints', 'cowboy_middleware']},
              {registered,[cowboy_clock,cowboy_sup]},
              {applications,[kernel,stdlib,ranch,cowlib,crypto]},
              {mod,{cowboy_app,[]}},
              {env,[]}]}.
