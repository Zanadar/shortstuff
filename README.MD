# Shortstuff
I built this little url shortener in a couple hours as an experiment with sinatra. I thought it was a fun thing, so I
deployed it.

## How?
It's available for use [here](https://shortstuff.herokuapp.com). It basically creates a dictionary with url
safe strings as key and the urls as values. When you navigate to your short url, it'll handle redirects. It
has some code that attempts to build valid urls even out of bad strings.

Right now it's using `pstore` for persistence, which is fine for the moment but not a real solution.
