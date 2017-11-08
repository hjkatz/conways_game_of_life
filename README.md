# Conway's Game of Life

# Install

`gem install bundler`
`bundle install`

# Test

`bundle exec rspec`

# CLI

`./cli.rb`

# Documentation

`bundle exec yardoc`

# Notes on Implementation

* The output specifies that the program should only print _after_ each
    iteration, so it does not print the initial board state.
* The program also does not print a newline after the input.
* This took me about 2.5 hours to complete.
    * I got a bit hung up on the wrapping implementation during testing, but
        after I figured out that I was using bad test cases everything seemed to
        come together.
    * This still needs a bunch more testing, and it takes a good chunk of time
        to hand craft test cases and edge cases with small enough boards that I
        can draw out and wrap my mind around.
* The cli.rb is _extremely_ bare bones because I feel the meat of the problem
    was for the implementation and not the integration with your testing
    harness.
