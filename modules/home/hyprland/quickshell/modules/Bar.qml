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

    // --- Horizontal Bar Settings ---
    anchors {
      top: true
      left: true
      right: true
    }
    implicitHeight: 40 // A good height for a top bar
    color: Settings.colors.background
    // --- End Horizontal Settings ---

    margins {
      left: 15
      right: 15
      top: 10
    }

    RowLayout {
      anchors.fill: parent
      spacing: 20

      // --- LEFT SIDE ---
      Launcher {}
      Workspaces {}

      // --- CENTER ---
      Item { Layout.fillWidth: true } // This is a spacer
      Clock {}
      Item { Layout.fillWidth: true } // This is a spacer

      // --- RIGHT SIDE ---
      SysTray {}
      Cpu {}
      Memory {}
      Battery {}
      Volume {}
      // We removed the custom "Network {}" to stop the duplicate icon
      Noti {}
    }
  }
}
