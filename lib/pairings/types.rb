module Pairings

  #---------------------------------------------
  # Input and output datatypes
  

  # Input player
  Player = Struct.new(:name, :rating)

  # Input game result
  GameResult = Struct.new(
    :round_number, :player1_name, :player1_score, :player2_name,
    :player2_score, :player1_started
  )

  RoundPairing = Struct.new(:round, :start_round, :strategy)
  
  # Input tournament
  Tournament = Struct.new(:game_results, :players, :round_pairings)

  # Output pairing
  Pairing = Struct.new(:player1, :player2, :repeats)


  #---------------------------------------------
  # Internal datatypes
  

  # Cumulative stats for a player
  PlayerStats = Struct.new(
    :name, :wins, :losses, :ties, :score, :spread, :starts
  ) do
    def bye?
      @name.downcase == "bye"
    end

    def self.make(name)
      self.new(name, 0, 0, 0, 0, 0, 0)
    end
  end


  # A single game result for a player
  Result = Struct.new(:name, :score, :opp_score, :start) do
    def spread
      score - opp_score
    end
  end

  
  # A collection of results
  class Results
    
    attr_accessor :players, :rounds, :results

    def initialize
      @players = Hash.new { |h, k| h[k] = PlayerStats.make(k) }
      @results = Hash.new { |h, k| h[k] = [] }
      @rounds = Hash.new { |h, k| h[k] = [] }
    end

    def add_game_result(gr)
      p1 = Result.new(
        gr.player1_name,
        gr.player1_score,
        gr.player2_score,
        gr.player1_started
      )
      p2 = Result.new(
        gr.player2_name,
        gr.player2_score,
        gr.player1_score,
        !gr.player1_started
      )
      update_player(p1)
      update_player(p2)
      update_round(gr)
    end

    def update_player(result)
      p = @players[result.name]
      p.spread += result.spread
      if result.spread > 0
        p.wins += 1
      elsif result.spread == 0
        p.ties += 1
      else
        p.losses += 1
      end
      p.score = p.wins + 0.5 * p.ties
      p.starts += result.start ? 1 : 0
    end

    def update_round(gr)
      rounds[gr.round_number] << gr
    end

    def standings
      players.values.sort_by {|p| -p.score}
    end

    def last_round
      rounds.keys.max
    end
  end


  # Repeats tracker
  class Repeats

    attr_reader :matches

    def initialize
      @matches = Hash.new(0)
    end

    def add(p1, p2)
      key = [p1, p2].sort
      matches[key] += 1
      matches[key]
    end

    def add_game_result(gr)
      add(gr.player1_name, gr.player2_name)
    end

    def get(p1, p2)
      key = [p1, p2].sort
      matches[key]
    end

  end


  # Starts tracker
  class Starts

    attr_reader :starts, :round_starts

    def initialize(data)
      @round_starts = []
      @starts = Hash.new(0)
    end

    def add(p1, p2, round)
      round_starts[round] ||= {}
      round_start = round_starts[round]
      if p1.bye?
        # bye always starts
        p1_starts = true
      elsif p2.bye?
        p1_starts = false
      else
        starts1, starts2 = starts[p1.name], starts[p2.name]
        if starts1 == starts2
          p1_starts = !round_start[p1.name]
        else
          p1_starts = starts1 < starts2
        end
      end
      if p1_starts
        starts[p1.name] += 1
        round_start[p1.name] = true
        round_start[p2.name] = false
      else
        starts[p2.name] += 1
        round_start[p1.name] = false
        round_start[p2.name] = true
      end
      p1_starts
    end

  end


  # Raw data for pairing
  class Data
    
    attr_reader :game_results, :players, :repeats

    def initialize(tournament)
      @game_results = tournament.game_results
      @players = tournament.players
      @player_lookup = {}
      @players.each {|p| @player_lookup[p.name] = p}
      @repeats = Repeats.new
    end

    def seeding
      players.sort_by { |p| -p.rating }
    end

    def results_after_round(round)
      res = Results.new
      game_results.select { |gr| gr.round_number <= round }.each do |gr|
        res.add_result_from_game_result(gr)
      end
      res
    end

    def standings_after_round(round)
      if round == 0
        seeding
      else
        results_after_round(round).standings.map {|p| @player_lookup[p.name]}
      end
    end

    def round_status
      # Have all the games in each round been completed?
      n = players.length / 2
      counts = Hash.new(0)
      for gr in game_results
        counts[gr.round_number] += 1
      end
      counts.transform_values do |v|
        if v == 0
          :empty
        elsif v == n
          :finished
        else
          :partial
        end
      end
    end

  end

end
