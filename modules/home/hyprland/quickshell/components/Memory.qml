import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: memRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: memContainer.implicitWidth
  Layout.preferredHeight: memContainer.implicitHeight
  
  property string used: "0.0G"

  Process {
    id: memoryProcess
    command: ["sh", "-c", "free -m | awk 'NR==2{printf \"%.1f/%.1fG\", $3/1024, $2/1024}'"]
    stdout: StdioCollector {
      onStreamFinished: memRoot.used = text
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: memoryProcess.running = true
  }

  RowLayout {
    id: memContainer
    spacing: 8
    
    // Memory Icon
    Text {
      text: ""
      color: Settings.colors.foreground
      font.pointSize: 11
      Layout.alignment: Qt.AlignCenter
    }
    
    // Memory usage
    Text { 
      id: memText
      text: memRoot.used
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
    }
  }
}
