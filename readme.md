#Leguan

* [What is Leguan?](#about)
* [Author](#author)
* [Compile](#compile)
* [Usage](#usage) 
* [License](#license)



## What is Leguan? <a name="about"></a>

Leguan is an escript to load code in erlang nodes.


## Author <a name="author"></a>

  * Pablo Vieytes mail@pablovieytes.com

## Compile <a name="compile"></a>

```shell
$ cd /path/to/project/
$ make
```
This project uses rebar. More info about rebar: https://github.com/basho/rebar

## Usage <a name="examples"></a>

To run the leguan escript must be leguan.config file in the same dir.

leguan.config:

```erlang
%% -*- erlang -*-

%% nodes
{nodes, ['dev1@127.0.0.1',
         'dev2@127.0.0.1',
         'dev3@127.0.0.1',
         'dev4@127.0.0.1']}.
          
%% cookie
{cookie, mycookie}.

%% code paths
{ebin, ["./ebin"]}.

%% modules
{modules, [test_module]}.

```

## License <a name="license"></a>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. 
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
