import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "root:/data"
import "root:/services"

Item {
  id: mediaRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: mediaLayout.implicitWidth
  Layout.preferredHeight: mediaLayout.implicitHeight
  
  visible: Media.selectedPlayer !== null && Media.selectedPlayer !== undefined
  
  RowLayout {
    id: mediaLayout
    spacing: 8
    
    // Previous button
    Text {
      text: "⏮"
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
      opacity: Media.selectedPlayer?.canGoPrevious ? 1.0 : 0.3
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Media.selectedPlayer?.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: Media.selectedPlayer?.canGoPrevious ?? false
        onClicked: {
          if (Media.selectedPlayer) {
            Media.selectedPlayer.previous()
          }
        }
      }
    }
    
    // Play/Pause button
    Text {
      text: Media.selectedPlayer?.playbackState === MprisPlaybackState.Playing ? "⏸" : "⏵"
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
      opacity: Media.selectedPlayer?.canPause || Media.selectedPlayer?.canPlay ? 1.0 : 0.3
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: (Media.selectedPlayer?.canPause || Media.selectedPlayer?.canPlay) ?? false
        onClicked: {
          if (Media.selectedPlayer) {
            Media.selectedPlayer.togglePlaying()
          }
        }
      }
    }
    
    // Next button
    Text {
      text: "⏭"
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
      opacity: Media.selectedPlayer?.canGoNext ? 1.0 : 0.3
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Media.selectedPlayer?.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: Media.selectedPlayer?.canGoNext ?? false
        onClicked: {
          if (Media.selectedPlayer) {
            Media.selectedPlayer.next()
          }
        }
      }
    }
    
    // Separator
    Text {
      text: "|"
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
      opacity: 0.5
    }
    
    // Song info
    Text {
      id: songInfo
      text: {
        if (!Media.selectedPlayer) return ""
        var metadata = Media.selectedPlayer.metadata
        if (!metadata) return ""
        
        var title = metadata.title || metadata["xesam:title"] || "Unknown"
        var artist = metadata.artist || metadata["xesam:artist"] || metadata.albumArtist || metadata["xesam:albumArtist"] || ""
        
        // Handle array of artists (common in browsers)
        if (Array.isArray(artist)) {
          artist = artist.join(", ")
        }
        
        var displayText = title
        
        var maxLength = 40
        return displayText.length > maxLength ? displayText.substring(0, maxLength) + "..." : displayText
      }
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
      Layout.maximumWidth: 400
      elide: Text.ElideRight
    }
  }
}
