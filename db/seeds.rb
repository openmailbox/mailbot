# Seed the database with some initial values in the absence of a better way to manage
# things via some kind of UI etc.
#
# Add channels to create a Twitch chat connection for each.
# Mailbot::Models::Channel.find_or_create_by(name: 'my_twitch_channel')

# The Kadgar job maintains a up-to-date list of live streamers in a specific Discord channel.
#details = { discord_channel_id: '12345', twitch_ids: %w{678 901} }
#Mailbot::Models::Kadgar.create!(frequency: 1800, details: details)

steam = NewsFeed.find_or_create_by(link: 'http://store.steampowered.com/feeds/news.xml')
newegg = NewsFeed.find_or_create_by(link: 'https://www.newegg.com/Product/RSS.aspx?Submit=RSSDailyDeals&Depa=0')
