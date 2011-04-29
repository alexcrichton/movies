# Movie Chain Runner

A description of our solution can be found [here](https://docs.google.com/document/d/13t8VYWdr3uWbwYcAlvhJ9ol7laXt58OLBPBpTzGh3Gw/edit?hl=en&authkey=CKPH0Z8D)

## Running the code

1. Download the code: `git clone git://github.com/alexcrichton/movies`
2. Compile the C programs: `make`
3. Generate the adjacency list: `make adjacent`
4. Run the program
  * Run manually via `./find <start> <run-time> <timeout-depth>`
  * Run distributed via `ruby scripts/open.rb`

## Running distributed

When running the program distributed, there's a few things you need to make sure are in order:

1. You have a login to CMU machines. If you can SSH into unix.andrew.cmu.edu, you're golden
2. Your AFS has a checkout of this repository in a folder called `movies`
3. The code has been compiled in this directory and the adjacency list is already generated.
  * This implies `~/movies/find` is a program and `~/movies/adj.lst` is a file containing the adjacency list

## Determining the Maximum Chain

The `find` program incrementally saves its progress so you can check up on it at any point in time.

Every maximum found is saved to `max/max-%d` where %d is the length of the chain that was found. These files contain space-delimited integers which correspond to movie titles.

To get the actual list of movie titles, run `./translate max/max-XXX`. This command will spit out the actual movie titles for enjoyment. There will be one movie title per line.
