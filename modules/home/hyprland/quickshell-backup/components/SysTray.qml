import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/data"
import Qt5Compat.GraphicalEffects // <-- Added for Colorize

RowLayout {
  id: systray
  spacing: 5
  Layout.alignment: Qt.AlignCenter
  visible: SystemTray.items.length > 0

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: delegate
      required property SystemTrayItem modelData
      Layout.preferredWidth: 16
      Layout.preferredHeight: 16
      
      Text {
        anchors.centerIn: parent
        text: "●"
        color: Settings.colors.foreground
        font.pointSize: 8
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: modelData.activate(0, 0)
      }
    }
  }
}


