//@ pragma IconTheme Cosmic
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import "root:/services"
import "root:/data"

Item {
  id: networkRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: netText.implicitWidth
  Layout.preferredHeight: netText.implicitHeight
  
  property string strengthSymbol: {
    if (!Networking.active) return "󰤮";
    var strength = Networking.active.strength;
    if (strength >= 80) return "󰤨";
    if (strength >= 60) return "󰤥";
    if (strength >= 40) return "󰤢";
    if (strength >= 20) return "󰤟";
    return "󰤯";
  }

  Text {
    id: netText
    text: networkRoot.strengthSymbol
    color: Settings.colors.foreground
    font.pointSize: 14
    Layout.alignment: Qt.AlignCenter
  }

  Process {
    id: nmEditor
    running: false
    command: ["kitty", "--class", "nmtui", "nmtui"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      nmEditor.running = true
    }
  }
}