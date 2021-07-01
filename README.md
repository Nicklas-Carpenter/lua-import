# lua_import
The last module you will ever `require()`.

## Table of Contents
- [lua_import](#lua_import)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Requirements](#requirements)
    - [Installation](#installation)
  - [Usage](#usage)
    - [Including](#including)
    - [Basic Usage](#basic-usage)
      - [Re-exportation Form](#re-exportation-form)
      - [Individual Import Form](#individual-import-form)
      - [Whole Module Import Form](#whole-module-import-form)
    - [Example](#example)
    - [Formal Specification](#formal-specification)
  - [Contributing](#contributing)
  - [License](#license)

## Description 
Work in progress. <!-- (also add rationale)? -->

## Setup
### Requirements
The only requirements to use `lua_import` is a working version of Lua (if you don't have a working version of Lua, what are you trying to use this module for?). It has only been tested with Lua v5.4.3, but it should work with earlier versions. 

### Installation
Installation is currently a work-in-progress. The current plan is to use a Makefile to install the modules in the proper and expected locations.

## Usage
### Including
To use `lua_import`, include it with `require("import")`  before including any other module. It isn't strictly necessary to require`lua_import` first, but the intention of `lua_import` is to replace the direct use of `require`, and it is not recommended to use `require` to include any module other than `lua_import`. The [example below](#example) demonstrates proper inclusion.

### Basic Usage
This section gives a basic overview of the usage of `lua_import` and should be sufficient for most users. A [more formal specification](#formal-specification) is given in a following section. 

`lua_import` has three basic forms as shown below:

```lua
-- Reexportation
import[[* from module]]

-- Individual import 
import[[member from module]]                               -- Importing a single member
import[[member1, member2, member3 from module]]            -- Importing multiple members from a module
import[[member1 as alias1, member2 as alias2 from module]] -- Importing multiple members and renaming them

-- Whole module import 
import[[module]]                                           -- Importing a single module
import[[module1, module2]]                                 -- Importing multiple modules
import[[module1 as alias1, module2 as alias2]]             -- Multiple modules renamed
```
Multiple instances of any form, including mixing different forms, can be included in a single import statement by seperating the forms with semi-colon. Below is a non-exhaustive list of examples of this:

```luat
-- Multiple instances of the same form
import[[* from module1; * from module2; * from module 3]]
import[[m1 from mod1; m1, m2 from mod2; m1 as member1, m2 as member2, m3 from mod3]]
import[[module1, module2; module3]] -- Discouraged since this form already allows importing multiple modules

-- Mix of different forms
import[[* from module1; m1, m2, m3 from module2; module3]]
import[[m1 as member1, m2 from module1; * from module2; module3 as mod3]]
```

In general, it is recommended to import from one module per import statement regardless of the form. For example:
```lua
import[[member1 as m1 from module1]] -- module1
import[[* from module 2]]            -- module2
import[[m1, m2, m3 from module3]]    -- module3
import[[module4]]                    -- module4
import[[module5]]                    -- module5
```

The following sections describe the different forms in more detail

#### Re-exportation Form
As implied by the name, re-exportation form re-exports all the members of an imported module. Every member of the specified module is extracted to a global variable within the namespace of the program; that is, for every member `mod.foo` on a module `mod`, `lua_import` extracts its value to a global variable `foo`. The use of this form is discouraged, since it pollutes the global namespace and risks collision with existing functions and variables. The general syntax from this form is:

```lua
import[[* from <module>]]
```
where `<module>` is the name of the module you want to import.

### Individual Import Form
Individual import form imports the specified members and only the specified members from the specified modules; it does not import anything else from the module. Each specified member can also be renamed to prevent namespace collision. This is the recommended import method, since it keeps the program small and avoids polluting the global namespace. The general syntax of this form (where anything in parantheses is optional) is:

```luat
import[[<member( as <alias>)(, ...) from <module>
```
Where `<module>` is the name of the module you want to import from, `<member>` is the name of the member you want to import, and `<alias>`, if specified, is the name of the global variable you want to hold the value of `module.member`. As the continuation (`...`) denotes, you can repeat the member and alias portion of the syntax to import multiple members from the module.

### Whole Module Import Form
The whole module import form imports and entire modules as a single table. It is equivalent to the traditional Lua statement `module = require("module")` (or `alias = require("module")` if an alias is specified). Multiple modules can be imported in this form by seperating them with commons, but, as stated above, it is recommened that for organization each module have its own separate import statemetn. The general syntax for this form (where anything in parantheses is optional) is:

```lua
import[[<module>( as <alias>)(, ...)]]
```

Where `<module>` is the name of the module you want to import and `<alias>`, if specified, is the name of the global variable you want to contain members of `module`.

### Example
In this example, we assume the modules `mod1`, `mod2`, and `mod3` exist as follows:

```lua
-- mod1.lua
local mod1 = { }
function mod1.a() print("mod1 a") end
function mod1.b() print("mod1 b") end
function mod1.c() print("mod1 c") end
return mod1

-- mod2.lua
local mod2 = { }
function mod2.a() print("mod2 a") end
function mod2.b() print("mod2 b") end
function mod2.c() print("mod2 c") end
function mod2.d() print("mod2 d") end
return mod2

-- mod3.lua
local mod3 = { }
function mod3.a() print("mod3 a") end
function mod3.b() print("mod3 b") end
function mod3.c() print("mod3 c") end
return mod3
```
A Lua program that includes and uses the modules declared above could be written as follows:

```lua
import = require("import")
import[[* from mod1]]
import[[a as x, b as y, c as z, d from mod2]]
import[[mod3]]

-- Using functions from mod1
a() --> prints "mod1 a"
b() --> prints "mod1 b"
c() --> prints "mod1 c"

-- Using functions from mod2t
x() --> prints "mod2 a"
y() --> prints "mod2 b"
z() --> prints "mod2 c"
d() --> prints "mod2 d"

-- Using functions from mod3
mod3.a() --> prints "mod3 a"
mod3.b() --> prints "mod3 b"
mod3.c() --> prints "mod3 c"
```

### Formal Specification
Coming soon.


## Future Work
Also coming soon.
<!-- well-behaved modules should refrain from declaring global variables, allowing the user instead to choose how to assign the module. -->

## Contributing
If you find any bugs or think of some new feature you think should be included, [create an issue](https://github.com/Nicklas-Carpenter/lua_import/issues) (if one doesn't already exists) and I'll get to it as soon as I can. If you are up to it, feel free to work on the feature yourself and [make a pull request](https://github.com/Nicklas-Carpenter/lua_import/pulls). Of course, if you think I am too slow (or too unwilling) to fix a bug and add a feature, you are always welcome to fork the project.

You can also reach me at carpenter.nicklas@gmail.com.

## License
This project is licensed under the GNU GPL v3 or later. For more information see [LICENSE](LICENSE).
