import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/data"
import "root:/components"

Variants {
  model: Quickshell.screens
  PanelWindow {
    property var modelData
    screen: modelData

    // Bar sits at the top with floating margins
    anchors {
      top: true
      left: true
      right: true
    }
    implicitHeight: 40
    color: "transparent"

    // Floating margins for rounded bar
    margins {
      left: 8
      right: 8
      top: 8
    }

    Rectangle {
      anchors.fill: parent
      color: Settings.colors.background
      opacity: 0.9
      radius: 10
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.1)

      // Centered clock (absolute positioning)
      Clock {
        anchors.centerIn: parent
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 20

        // --- LEFT SIDE ---
        RowLayout {
          spacing: 30
          Layout.alignment: Qt.AlignLeft
          
          Workspaces {}
          MediaPlayer {}
        }

        // Spacer to push right side
        Item { Layout.fillWidth: true }

        // --- RIGHT SIDE ---
        RowLayout {
          spacing: 15
          Layout.alignment: Qt.AlignRight
          
          // Stats widgets
          Cpu {}
          Memory {}
          Battery {}
          Network {}
          
          // System Icons
          Volume {}
          Noti {}
        }
      }
    }
  }
}
