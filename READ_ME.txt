@author: Nils Müllner (earthphoenix@gmx.de)

The following code writes the test steps for a train control management system, as explained in http://www.informatik.uni-oldenburg.de/~phoenix/docs/KV.pdf (preprint).

This code -- written in Erlang -- generates a sequence of test steps according to the settings in the header file

gen_script_config.hrl

Compile the source code from the Erlang bash (mind you are in the correct folder) with 

c(gen\_script).

 and execute it with 

gen_script(start).