# Alis
by Sergey Potaov (aka Blake)

## Why?

In some cases `alis` UNIX tool can not satisfy us. For example how would make `gem install` use `--no-rdoc` and `--no-ri` options by default? That is why I create Alis. Alis is more flexible tool to create aliases.

## Installation

Install alis ruby gem:

    gem install alis

And then do:

    alis install


## Usage

To get help run

    alis --help

You can create, remove and list aliases with appropriate commands.

To make `gem install` use `--no-rdoc` and `--no-ri` options just do:

    alis set --alias 'gem install' --tail '--no-rdoc --no-ri'

To list you aliases do:

    alis list

And the output must be something like this:

    ALIAS           EXECUTE         TAIL             
    gem install     gem install     --no-ri --no-rdoc

`ALIAS` is what you type (alias name) to execute command.

`EXECUTE` is what will be really executed. (if it's not specified it is the same as ALIAS)

`TAIL` is additional options or arguments which will be added to tail of command you typed.

This means when you run `gem install gem_name` next time really will be executed `gem install gem_name --no-rdoc --no-ri`

    
## How does it work?

When you run `alis install` it creates $HOME/.alis directory and modifies your .bashrc file to include $HOME/.alis/bin to PATH variable.

When you create a new alias Alis creates executable file in $HOME/.alis/bin which handles aliases and runs original command.

To locate original command you can use `alis which`:

    which gem
    /home/john_doe/.alis/bin/gem
    alis which gem
    /usr/bin/gem


## License

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston,
MA 02111-1307 USA
