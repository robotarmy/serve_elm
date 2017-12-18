defmodule ServeElmWeb.Runtime do
	import Execjs.Runtime

	defruntime Node8,
    command: "/Users/o_o/.nvm/versions/node/v8.9.3/bin/node",runner: "node_runner.js.eex"

end
