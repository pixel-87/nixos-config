pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root
  property MprisPlayer selectedPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
  property list<MprisPlayer> players: Mpris.players.values
}
