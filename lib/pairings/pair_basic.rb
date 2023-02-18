module Pairings

  module Strategies

    # -----------------------------------------------------
    # King of the Hill

    def pair_koth(rp)
      # King of the hill pairing.
      standings = pd.standings_after_round(rp.start_round)
      return standings.each_slice(2)
    end


    # -----------------------------------------------------
    # Queen of the Hill

    def pair_qoth(rp)
      # Queen of the hill pairing.
      standings = pd.standings_after_round(rp.start_round)
      pairings = []
      n = standings.length
      if n % 4 == 2
        last = n - 6
        for i in (0...last).step(4)
          pairings << [standings[i + 0], standings[i + 2]]
          pairings << [standings[i + 1], standings[i + 3]]
          # Pair the last six players 1-4,2-5,3-6 if we don't have a
          # multiple of 4
          pairings << [standings[last + 0], standings[last + 3]]
          pairings << [standings[last + 1], standings[last + 4]]
          pairings << [standings[last + 2], standings[last + 5]]
        end
      else
        for i in (0...n).step(4)
          pairings << [standings[i + 0], standings[i + 2]]
          pairings << [standings[i + 1], standings[i + 3]]
        end
      end
      return pairings
    end

  end
end
