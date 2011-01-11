# Why am I writing LSL

I have a confession to make: I hate shell scripting, and I suck at it.  Maybe I don't like it because I'm bad at it, maybe I'm bad at it because I don't like it, I don't know.

I love the *idea* of shell scripting, just not the reality.
* The ability to perform common tasks quickly and concisely.  
* The unix philosophy of discrete tools each doing one thing, communicating via a uniform method (stdout).
* The similarity to functional programming, each discrete piece piping output along the chain.

I love scripting languages.  Ruby is my drug of choice, but I can imagine others feeling the same way about Python (or Perl, if I really use my imagination).  I tend to use Ruby for most tasks, whether it's a large project or a quick task that could be done with a simple shell script.  

Using Ruby for shell-like tasks works great.  I almost always end up with a clean, concise, maintainable solution, as non-shell code goes.  The one thing I miss is the incredibly concise syntax of a shell script.  The whole syntax is built around short, easily typeable, readable lines of code.

My vision with LSL is to combine the power and beauty of scripting languages with the friendly syntax of the shell.

# Basic Functionality

The goal of LSL is to layer a thin layer of shell-like syntax on top of a scripting language, while always allowing commands to "fall through" to the shell.

A line in LSL is 1 or more commands, seperated by operators, with optional output redirection.

## Commands

Each command consists of the executable/function (which I will be calling the executable), followed by 0-N optionally quoted arguments and 0-N option flags.  

The executable can be any of the following
* A normal ruby function
* A user-defined code block
* A standard program executable from the command line 

If a command uses an executable that has not been defined, LSL attempts to "fall through" and execute the raw text of the command at the shell.  The goal is to allow users to use LSL as a "shell replacement" by adding functionality on top of the shell, without obscuring any existing shell functionality.  

LSL includes some built in executables that are often useful.  Users can define their own executables in a .lsl file.  
Note that currently (and confusingly), the term "mapping" is used.  The terminology will be standardized in the near future.

    LSL.configure do |s|
      s.mapping_with_ops :concat do |*args|
        ops = args.pop
        args.join(ops['sep']||'')
      end
    end

*To be continued*

== Contributing to lsl
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2010 mharris717. See LICENSE.txt for
further details.
