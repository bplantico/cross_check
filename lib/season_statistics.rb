module SeasonStatistics
  def biggest_bust(season)
    data = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        post_season_won: 0,
        post_season_lost: 0,
        post_season_win_percentage: 0,
        regular_season_won: 0,
        regular_season_lost: 0,
        regular_season_win_percentage: 0,
        biggest_bust_value: 0}
      hash
    end
    season_data = @combine_data.find_all{|record| record[:season].to_s == season.to_s}
    season_data.map do |row|
      if row[:type] == 'P'
        data[row[:team_name]][:post_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:post_season_lost] += 1 if row[:won].to_s == "FALSE"
      elsif row[:type] == 'R'
        data[row[:team_name]][:regular_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:regular_season_lost] += 1 if row[:won].to_s == "FALSE"
      end
      if data[row[:team_name]][:post_season_won] > 0 || data[row[:team_name]][:post_season_lost] > 0
        data[row[:team_name]][:post_season_win_percentage] = (data[row[:team_name]][:post_season_won].to_f / (data[row[:team_name]][:post_season_won] + data[row[:team_name]][:post_season_lost])) * 100
        data[row[:team_name]][:regular_season_win_percentage] = (data[row[:team_name]][:regular_season_won].to_f / (data[row[:team_name]][:regular_season_won] + data[row[:team_name]][:regular_season_lost])) * 100
        data[row[:team_name]][:biggest_bust_value] = data[row[:team_name]][:post_season_win_percentage] - data[row[:team_name]][:regular_season_win_percentage]
      end
    end
    data.min_by{|team| team[1][:biggest_bust_value]}[0]
  end

  def biggest_surprise(season)
    data = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        post_season_won: 0,
        post_season_lost: 0,
        post_season_win_percentage: 0,
        regular_season_won: 0,
        regular_season_lost: 0,
        regular_season_win_percentage: 0,
        biggest_bust_value: 0}
      hash
    end
    season_data = @combine_data.find_all{|record| record[:season].to_s == season.to_s}
    season_data.map do |row|
      if row[:type] == 'P'
        data[row[:team_name]][:post_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:post_season_lost] += 1 if row[:won].to_s == "FALSE"
      elsif row[:type] == 'R'
        data[row[:team_name]][:regular_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:regular_season_lost] += 1 if row[:won].to_s == "FALSE"
      end
      if data[row[:team_name]][:post_season_won] > 0 || data[row[:team_name]][:post_season_lost] > 0
        data[row[:team_name]][:post_season_win_percentage] = (data[row[:team_name]][:post_season_won].to_f / (data[row[:team_name]][:post_season_won] + data[row[:team_name]][:post_season_lost])) * 100
        data[row[:team_name]][:regular_season_win_percentage] = (data[row[:team_name]][:regular_season_won].to_f / (data[row[:team_name]][:regular_season_won] + data[row[:team_name]][:regular_season_lost])) * 100
        data[row[:team_name]][:biggest_bust_value] = data[row[:team_name]][:post_season_win_percentage] - data[row[:team_name]][:regular_season_win_percentage]
      end
    end
    data.max_by{|team| team[1][:biggest_bust_value]}[0]
  end

  def most_accurate_team(season)
    teams_array = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        shots_on_goal: 0,
        goals: 0,
        average: 0}
      hash
    end
    @combine_data.each do |game|
      if game[:season].to_s == season.to_s
        teams_array[game[:team_name]][:shots_on_goal] += game[:shots]
        teams_array[game[:team_name]][:goals] += game[:goals]
        teams_array[game[:team_name]][:average] = (teams_array[game[:team_name]][:goals] / teams_array[game[:team_name]][:shots_on_goal].to_f) * 100
      end
    end
    teams_array.max_by{|team| team[1][:average]}[0]
  end

  def winningest_coach(season)
    coachs = @combine_data.each_with_object({}) do |game, hash|
      if game[:season] == season.to_i
        hash[game[:head_coach]] = {wins: 0, games: 0, average_wins: 0} if hash[game[:head_coach]].nil?
        hash[game[:head_coach]][:games] += 1
        hash[game[:head_coach]][:wins] += 1 if game[:won] == "TRUE"
        hash[game[:head_coach]][:average_wins] = hash[game[:head_coach]][:wins].to_f / hash[game[:head_coach]][:games]
      end
    end
    coachs.max_by{|coach| coach[1][:average_wins]}.first
  end

  def worst_coach(season)
    coachs = @combine_data.each_with_object({}) do |game, hash|
      if game[:season] == season.to_i
        hash[game[:head_coach]] = {wins: 0, games: 0, average_wins: 0} if hash[game[:head_coach]].nil?
        hash[game[:head_coach]][:games] += 1
        hash[game[:head_coach]][:wins] += 1 if game[:won] == "TRUE"
        hash[game[:head_coach]][:average_wins] = hash[game[:head_coach]][:wins].to_f / hash[game[:head_coach]][:games]
      end
    end
    coachs.min_by{|coach| coach[1][:average_wins]}.first
  end

end
