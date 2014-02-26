# NAME

Cookie::Baker::XS - boost Cookie::Baker's crush\_cookie

# SYNOPSIS

    use Cookie::Baker::XS qw/crush_cookie/;
    

    my $cookies_hashref = crush_cookie($headers->header('Cookie'));

# DESCRIPTION

Cookie::Baker::XS provides cookie string parser that implemented by XS.
This modules only provides parser, does not have a generator function.

For more details, see [Cookie::Baker](http://search.cpan.org/perldoc?Cookie::Baker)'s document

# BENCHMARK

    ## length($cookie) == 600
    Benchmark: running pp, xs for at least 1 CPU seconds...
            pp:  1 wallclock secs ( 1.06 usr +  0.00 sys =  1.06 CPU) @ 16904.72/s (n=17919)
            xs:  1 wallclock secs ( 1.06 usr +  0.00 sys =  1.06 CPU) @ 170835.85/s (n=181086)
           Rate   pp   xs
    pp  16905/s   -- -90%
    xs 170836/s 911%   --
    

    ## length($cookie) == 17
    Benchmark: running pp, xs for at least 1 CPU seconds...
            pp:  1 wallclock secs ( 1.07 usr +  0.00 sys =  1.07 CPU) @ 214370.09/s (n=229376)
            xs:  1 wallclock secs ( 1.12 usr +  0.00 sys =  1.12 CPU) @ 1117090.18/s (n=1251141)
            Rate   pp   xs
    pp  214370/s   -- -81%
    xs 1117090/s 421%   --

# SEE ALSO

[Cookie::Baker](http://search.cpan.org/perldoc?Cookie::Baker)

# LICENSE

Copyright (C) Masahiro Nagano.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Masahiro Nagano <kazeburo@gmail.com>
