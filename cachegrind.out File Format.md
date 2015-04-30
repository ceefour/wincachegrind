# cachegrind.out File Format

by [Hendy Irawan](http://www.hendyirawan.com/)

I found little information on http://courses.cs.washington.edu/courses/cse326/05wi/valgrind-doc/cg_main.html and 
http://courses.cs.washington.edu/courses/cse326/05wi/valgrind-doc/cg_techdocs.html .
But here's what I've found (they maybe very incorrect though so beware):

Note that this ONLY applies to xdebug 2 `cachegrind.out` files.

The file is divided into several parts, separated by blank lines. Note that blank lines are also used to separate entries in a part.

## HEADER PART

	version: <version>
	cmd: <command>
	part: <part number/count?>

## EVENTS PART

	events: <space separated list of events?>

## BODY PART

This is a list of functions in chronological order (i.e. order of execution).

	fl=<filename>
	fn=<function name>
	<line number> <time> <unknown>

* `<line number>` can be 0.

* `<time>` is measured in time units, where 1 second is 10 million time units.

	Note that `<time>` is exclusive, meaning it doesn't count time spent for called functions.
	
	A special function name is `{main}`. After `fn={main}` there is no line number or time.

If a function calls other functions, the deepest function will show up first then the caller functions later. After the function data above here comes the called functions list, separated by nothing (not using blank lines).

	cfn=<called function>
	calls=<unknown> <unknown> <unknown>
	<line number> <time>

`<line number>` is never 0 in this case.

The `<time>` here is inclusive, which means the total time the called function runs along with its children.

## SUMMARY PART

	summary: <total time>

`<total time>` is unreliable as of xdebug 2.0.0 beta 1.

## MAIN PROGRAM PART

After summary seems to be the main program profile.

	0 <main program time>
	cfn=<called function>
	calls=<unknown> <unknown> <unknown>
	<line> <time>

The `<time>` here is also inclusive.

It is (I guess) safe to assume that `<line>` is line from the file specified in
the last entry in the *BODY PART*, or in some cases the file `<cmd>`.

## DESTRUCTOR PART

This part exists only if there are destructors or exit procedures.
Why it's not included in "main program" is because these are called not by
main program but by PHP mechanism.

The entries here are identical to *BODY PART*.

## File and Function Name Compresssion

See http://valgrind.org/docs/manual/cl-format.html#cl-format.overview.compression1

Original issue: https://github.com/ceefour/wincachegrind/issues/1

Thanks to Stéphane Boisvert for donation. :)
