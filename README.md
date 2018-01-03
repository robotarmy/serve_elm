openssl genrsa -out priv/keys/localhost.key 2048
openssl req -new -x509 -key priv/keys/localhost.key -out priv/keys/localhost.cert -days 3650 -subj /CN=localhost


--- Version 1

-- To Compile elm:

./compile-elm.sh
-- To Start phoenix ( install elixir with "brew install elixir" )

mix deps.get
mix phx.server

Version 1 embeds the elm client in the view (wrapped in a setTimeout) it is interesting
to experiment with the setTimeout to simulate network delay.

Notice that elm does not do any flash or seem to re-draw at all.. simply becomes ready for events.

Because of this it may be sufficent to simply deliver static-html and then the elm client for various pages 
(supporting both mobile and SEO bots at the same time!)



--- Version 0
This is a Proof of concept for server side execution of elm code.

ExecJS has some internal modifications 1) async/await in the wrapper script template 2) using nouse_stdio in the erlang port configuration 3) modified output from node to be delivered over file descriptor : 4 (as per nouse_stdio )

I've also declared an ExecJS runtime for Node8 executable

Much of this has hardcoded paths due to the proof of concept nature of this spike.

ElmStaticHtmlLib is doing both elm-package manangement and compilation and execution of the elm script.

The original Elm code is from phoenix-and-elm (https://github.com/bigardone/phoenix-and-elm/)

I wrote a shim in Elm called StaticMain that represents a wrapper for the view execution.

Modifications to execjs were made in these files:

deps/execjs/priv/node_runner.js.eex
deps/execjs/lib/execjs.ex

i


