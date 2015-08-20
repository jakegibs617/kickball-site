require 'pry'
require 'json'
require "sinatra"
# http://localhost:4567/home

require 'json'
def parse_roster
  json_string = IO.read('roster.json')
  JSON.parse(json_string)
binding.pry
end

def find_teams
  teams = []
  parse_roster.each do |team, info|
    team = Team.new(team)
    teams << team
  end
  teams
end

class Team
  attr_accessor :name, :players

  def initialize(name)
    @name = name
    @players = []
  end
end

class Player
  attr_accessor :name, :position, :team

  def initialize(name, position, team)
    @name = name
    @position = position
    @team = team
  end
end

teams = find_teams

players = []

parse_roster.each do |team, info|
  info.each do |position, name|
    player = Player.new(name, position, team)
    players << player
  end
end
players.each do |player|
    team = teams.find { |team| team.name == player.team }
    team.players << player
end


# teams.each do |team|
#   team.players.each do |player|
#     puts "#{player.name} is the #{player.position} for the #{team.name}."
#   end
#   puts ""
# end

# players.each do |player|
#   puts "#{player.name} plays #{player.position} for the #{player.team}."
#   puts ""
# end


set :public_folder, File.join(File.dirname(__FILE__), "public")
get "/" do
  erb :index, locals: { teams: teams }
end

get "/teams/:team_name" do
  this_team = players.select {|player| player.team == params[:team_name]}
  erb :show, locals: {this_team: this_team, team_name: params[:team_name]}
end

get "/positions/:position" do
  players_by_position = players.select {|player| player.position == params[:position]}
  erb :positions, locals: {players_by_position: players_by_position, position: params[:position]}
end
