# Pairings

A ruby library for tournament pairings.

`pairings` is currently focused on scrabble tournaments, but is open to feature
requests (and pull requests!) for other pairing requirements.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pairings

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pairings

## Usage

The pairer operates on the complete record of a tournament-in-progress, rather
than a snapshot of the current standings, since it takes repeats and balanced
starts into account.

### Input data

* Players: An array of `Pairings::Player(name, rating)` listing the players in
  the tournament
* Round pairings: An array of `Pairings::RoundPairing(round, start_round,
  strategy)`, containing the pairing strategy for every round. Every round
  could potentially use a different pairing strategy.
* Game results: The results for every game played so far.

```
open Pairings

tournament = Tournament.new(game_results, players, round_pairings)
pairer = Pairer.new(tournament)
pairings = pairer.pair
```

`pairer.pair` returns an array of `[[round_number, pairings], ...]` for all
pairable rounds, where `pairings` is itself an array of
[`Pairings::Pairing(player1, player2, repeats), ...]`

After running `pairer.pair`, the `pairer` object contains starts and repeats in
`pairer.starts` and `pairer.repeats` respectively.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/martindemello/pairings-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
