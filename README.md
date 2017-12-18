This is a Proof of concept for server side execution of elm code.

ExecJS has some internal modifications 1) async/await in the wrapper script template 2) using nouse_stdio in the erlang port configuration 3) modified output from node to be delivered over file descriptor : 4 (as per nouse_stdio )

I've also declared an ExecJS runtime for Node8 executable

Much of this has hardcoded paths due to the proof of concept nature of this spike.

ElmStaticHtmlLib is doing both elm-package manangement and compilation and execution of the elm script.

The original Elm code is from phoenix-and-elm (https://github.com/bigardone/phoenix-and-elm/)

I wrote a shim in Elm called StaticMain that represents a wrapper for the view execution.

