require 'structr'

require 'riot'
require 'riot_notifier'

Riot.reporter = RiotNotifier::Libnotify
