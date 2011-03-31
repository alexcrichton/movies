## Proposal

- [Presentation](https://docs.google.com/present/edit?id=0AaUaVEtntL3PZGhuazl2MnBfMTYweGN2eGYyZjU&hl=en)
- Paper (fill this link in)

## Maximum Overlap of any two titles

    ruby max-length.rb

The answer we've gotten is __six__, `HENRY PORTRAIT OF A SERIAL KILLER` vs
`HENRY PORTRAIT OF A SERIAL KILLER PART 2`

## Maximum Length of any title

    ruby max-length.rb

So far it's __92__

## Number of unique words

    ruby unique-words.rb

So far it's __5714__

## Ideas

- 5147 words means that everything can fit into 13 bits
- Comparing integers is faster than comparing strings
  - Store all words as integers (hashed, 13+ bits)
- Can pack prefixes/suffixes into 32-64 bits (still integer comparison)
- Generate list of 2 movie titles concatenated
  - Save to disk?
  - Generate 3-long based off of 1 and 2 length titles?