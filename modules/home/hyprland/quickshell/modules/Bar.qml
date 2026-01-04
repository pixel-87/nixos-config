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

    // --- LEFT BAR ---
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: leftRow.implicitWidth + 45
      color: Settings.colors.background
      opacity: 0.9
      radius: 10
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.1)

      RowLayout {
        id: leftRow
        anchors.centerIn: parent
        spacing: 20
        
        // NixOS Icon
        Text {
          text: ""
          color: Settings.colors.foreground
          font.pointSize: 14
          Layout.alignment: Qt.AlignCenter
          Layout.rightMargin: 5
        }

        Workspaces {}
        MediaPlayer {}
      }
    }

    // --- CENTER BAR ---
    Rectangle {
      anchors.centerIn: parent
      height: parent.height
      width: clockComp.implicitWidth + 40
      color: Settings.colors.background
      opacity: 0.9
      radius: 10
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.1)

      Clock {
        id: clockComp
        anchors.centerIn: parent
      }
    }

    // --- RIGHT BAR ---
    Rectangle {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: rightRow.implicitWidth + 30
      color: Settings.colors.background
      opacity: 0.9
      radius: 10
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.1)

      RowLayout {
        id: rightRow
        anchors.centerIn: parent
        spacing: 15
        
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
