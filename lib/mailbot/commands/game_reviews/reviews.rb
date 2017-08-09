module Mailbot
  module Commands
    module GameReviews
      class Reviews
        def initialize(user, args)
          @user = user
          @args = args
        end

        def execute(context)
          Mailbot.logger.info "USER COMMAND: #{user.name} - !review #{args}"

          if args.any?
            search_text = args.join(' ')
            games       = find_game(search_text)

            if games.count == 1
              count   = games.first.reviews.count
              average = games.first.reviews.average(:rating)

              message =  "#{games.first.name} has an average rating of #{average} stars "
              message << "across #{count} reviews in this community."

              context.send_string(message)
            elsif games.count > 1
            else
              context.send_string("Unable to find a game named: #{search_text}")
            end
          else
            message =  "Add a community game review with '!addreview <game> <1-5>'. "
            message << "See the community average for a game with '!reviews <game>'."

            context.send_string(message)
          end
        end

        private

        def find_game(name)
          Models::Game.where("LOWER(name) REGEXP ?", name)
        end
      end
    end
  end
end
