
Example UGens
=============

An example UGen written in the Nim programming language to serve as a starting point. 

This program copies the first input to the first output

Build
-----

*Install dependencies*

- Install the [Nim compiler](https://nim-lang.org)

- Install scnim

    nimble install scnim

*Build*

    nim build ExampleUGens.nim

*Install*

After building, copy the entire folder to your SuperCollider extensions

    # Linux
    cp -R $(pwd) ~/.local/share/SuperCollider/Extensions

*Run*

Open `example.scd` in a SuperCollider IDE and run it

License
-------
Copyright (c) 2018 Example. Licensed under the GNU General Public License 2.0 or later.

