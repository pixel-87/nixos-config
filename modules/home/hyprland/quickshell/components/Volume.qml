import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import "root:/data"

IconImage {
  id: volumeIcon
  source: Quickshell.iconPath("audio-volume-high-symbolic")
  width: 20  
  height: 20 
  Layout.alignment: Qt.AlignCenter

  MouseArea {
    anchors.fill: parent
    onClicked: {
      Quickshell.run(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
    }
  }
}
