# CommuterService

**TODO: Proper Readme**

## Setting up this Repo locally
Getting this set up is as simple as a few commands, but you need Elixir installed
on to your machine. The Elixir Docs have an [easy install guide](http://elixir-lang.org/install.html).

Once you've got that installed, just clone the directory and `cd` into it...  

Install dependencies with `mix deps.get`  
Run tests with `mix test`  
Start iex with `iex -S mix`  

## Start the station supervisor
Currently, the station supervisor needs to be started manually (this is TODO to fix)  

To start:
`Commuter.Station.StationSupervisor.start_link`  

You'll then create a GenServer process for each station/line combination.    

Each process will be named after the station_id and the line_id, and because of
the format of station id's specified by TFL, it will look like this:

`:"90577GXBAL_northern"`

## Get Arrivals for a specific station

Currently, you need to manually enter a command to get the arrivals for a line
at a station (this is, again, a TODO to fix.)  

For now, you'll have to know the process ID of the station/line combination. It's
quite easy to look this up: just take the station_id and the line_id and make it
an atom (wrapped in quotes...)

So, to call Tooting Bec's Northern Line arrivals:

`Commuter.Station.get_arrivals(:"940GZZLUTBC_northern")`
