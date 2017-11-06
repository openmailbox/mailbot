# Seed the database with some initial values in the absence of a better way to manage
# things via some kind of UI etc.
#
# Add channels to create a Twitch chat connection for each.
# Mailbot::Models::Channel.find_or_create_by(name: 'my_twitch_channel')

# The Kadgar job maintains a up-to-date list of live streamers in a specific Discord channel.
#details = {
#  discord_channel_id: '342737052703391765',
#  twitch_ids:         %w{133652118
#                         122233584
#                         83111366 
#                         61328956 
#                         79397878 
#                         68442684 
#                         118029540
#                         69300188 
#                         141540943
#                         123616230
#                         36838233 
#                         20921990 
#                         90252824 
#                         49623984 
#                         139605001
#                         145025615
#                         144366639
#                         28051039 
#                         153261993
#                         49882644 
#                         78641303 
#                         103248261
#                         107110706
#                         70124234 
#                         63760916}
#}
#
#Mailbot::Models::Kadgar.create!(frequency: 1800, details: details)
