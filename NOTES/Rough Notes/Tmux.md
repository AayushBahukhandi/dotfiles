SESSIONS ->
		 `tmux`  this will start a new session\
		 `tmux a` this will open the previous session 
		 `tmux <c-d>` detach from session
		 `tmux ls` to list all sessions
		 `tmux new -s superman` this will create session with superman name
		 `tmux a -t 0` to attach to the index 0 or whatever the session name
		 `tmux kill-session -t superman` to kill particular session
		 

PANES ->
		 `<c-%>` this will create vertical pane
		 `<c-">` this will create horizontal pane

NAVIGATION ->
		 `<c-q>` to see all indexing 
		 `<c-q> 1` index to navigate that pane 
		 `<c-arrowkey>` to navigate pane
		 `<c-controlhold arrowkey>` to resize pane
		 `<c-alt 1-5>` to change pane style

WINDOW ->
		 `<c-c>` to create new window
		 `<c-n or p>` to navigate window
		 `<c-,>` to rename a window
		 `<c-w>` to list all window 
		 `<c-2> ` to navigate particular window
		 `<c-x>` to delete panel
		 `<c-d>` to delete panel
		 `<c-&>` to kill window
		 
to kill all server `tmux kill-server`

`<c-[>` to copy the code or use mouse `<c-]>` to paste code
`<c-$>` to rename session

*if config wont work try to kill server first*