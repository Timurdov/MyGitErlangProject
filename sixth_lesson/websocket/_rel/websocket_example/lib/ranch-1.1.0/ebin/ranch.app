{application,ranch,
             [{description,"Socket acceptor pool for TCP protocols."},
              {vsn,"1.1.0"},
              {id, "1.1.0-dirty"},
              {modules, ['ranch_listener_sup', 'ranch', 'ranch_tcp', 'ranch_ssl', 'ranch_acceptor', 'ranch_conns_sup', 'ranch_server', 'ranch_sup', 'ranch_protocol', 'ranch_transport', 'ranch_acceptors_sup', 'ranch_app']},
              {registered,[ranch_sup,ranch_server]},
              {applications,[kernel,stdlib]},
              {mod,{ranch_app,[]}},
              {env,[]}]}.
