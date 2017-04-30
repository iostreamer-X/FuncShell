# FuncShell
Pimp your shell by making it functional through Haskell! (An update to [Awkward](https://github.com/iostreamer-X/Awkward))

![](/fsh.gif)

## What is it?
This program is an alternative to 'awk' or at least tries to be, and lets you perform
'awk' like operations through Haskell. So, if you know basic Haskell syntax, you are already set.

## Why is it?
As an exercise, I wanted to update [Awkward](https://github.com/iostreamer-X/Awkward) but in Haskell. A few minutes with Awkward and you would notice its drawbacks.

Since Awkward is a shell and that too a minimal at best, a lot of your customized shell's
functionality is lost. Hence I decided to implemented FuncShell as an executable program and rely on pipes.

## Philosophy
fsh follows the same philosophy as Awkward. Output of most bash commands can be expressed as [[String]] or [String]
and one can use standard Haskell functions to modify this data representation.

Additionally, Haskell's pattern matching works really well with this representation. And its
lambda functions along with partially applied operator functions ((+3) or (++" append") etc) make the syntax clean.

## How does it work?
The command output is relayed to the executable through pipes. That output looks like this:

``` shell
  PID TTY          TIME CMD
13750 pts/14   00:00:00 bash
25193 pts/14   00:00:03 node
25271 pts/14   00:00:00 sh
25272 pts/14   00:00:00 ps
```
This is parsed, cleaned and converted to something like this:
``` js
[ [ "PID", "TTY", "TIME", "CMD" ],
[ "13750", "pts/14", "00:00:00", "bash" ],
[ "25283", "pts/14", "00:00:00", "sh" ],
[ "25284", "pts/14", "00:00:00", "ps" ] ]
```

The function you provide, let's say `filter (\(pid:_) -> read pid > 9000)` is applied
over this data structure. The headers are handled appropriately.

## Installing

```bash
wget "https://github.com/iostreamer-X/FuncShell/blob/master/fsh?raw=true" -O fsh && sudo chmod +x fsh && sudo mv fsh /usr/local/bin
```
You might need to install `libgmp-dev` for this to work.

## Usage
After installing, you can use this program through `fsh`. I aliased it as '[',
so my usages look like this.

```bash
la |] -p table 'filter (\(_:_:_:_:_:month:_) -> month == "Oct")'
```

The program expects the input to be received through pipes, always.

Next, it has a few flags.
You can use `-h` to get help, and `-p` to choose your parser.

`fsh` **supports plugins**, which means you can install external modules through `cabal`(package manager, you can think of it as npm)
and get them to work with `fsh`

And finally, you are supposed to supply a haskell function. The function must take an input of type [[String]] and give an output of the same type.

To sum up, this is how this program is supposed to be used:

`bash command |fsh flags 'haskell function'`

## Parsers
You can use the `-p` flag to choose your parser, depending on the kind of output you are expecting from the command.
For example, `ls` gives a simple list, so the default parser is used and hence there is no need to specify anything.
Whereas, the `ps` command outputs a table, hence you must specify the table parser through `-p table`.

The parsers mentioned above are built-in. You can also download and install external parsers. To do that you'd need `cabal`.
Once installed, `cabal update && cabal install fsh-csv` will install the csv parser.

To use it, do `echo "a,b,c\n1,2,3" |] -p FSH_CSV 'myHaskellFunction'`

# Plugins

Making plugins/external parsers is really easy and involves very little fuss. All you need to do is:

- Make a library project(Using cabal or something else if you want).
- Build a function named `run` with type signature `run :: [Char] -> String -> IO ()`. The first argument is the function, and the last is command output
- Publish to hackage
- Rejoice!

I use `hint` to import `run` from your module and use it as a local function.

Here is the implementation of [TableParser](https://github.com/iostreamer-X/FuncShell/blob/master/src/TableParser.hs) to give you an idea. I used this as a base to
make the csv parser.
