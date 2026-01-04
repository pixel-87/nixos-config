import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: cpuRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: cpuContainer.implicitWidth
  Layout.preferredHeight: cpuContainer.implicitHeight
  
  property string percent: "0%"
  property var history: []
  property bool showPunchcard: false

  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        const value = parseFloat(text).toFixed(0)
        cpuRoot.percent = value + "%"
        
        // Create new array to trigger binding update
        let newHistory = [parseInt(value)];
        for (let i = 0; i < cpuRoot.history.length && i < 23; i++) {
            newHistory.push(cpuRoot.history[i]);
        }
        cpuRoot.history = newHistory;
      }
    }
  }
  
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: cpuProcess.running = true
  }

  RowLayout {
    id: cpuContainer
    anchors.centerIn: parent
    spacing: 8
    
    // CPU Icon
    Text {
      text: "󰍛"
      color: Settings.colors.foreground
      font.pointSize: 11
      Layout.alignment: Qt.AlignCenter
    }
    
    // CPU percentage
    Text { 
      id: cpuText
      text: cpuRoot.percent
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
    }

    // CPU Graph
    Row {
      Layout.preferredHeight: 20
      Layout.preferredWidth: 60
      spacing: 1
      Layout.alignment: Qt.AlignCenter
      
      Repeater {
        model: 20
        Rectangle {
          width: 2
          anchors.bottom: parent.bottom
          radius: 1
          
          // Calculate index: 0 is left (oldest), 19 is right (newest)
          property int historyIndex: 19 - index
          
          height: {
            if (historyIndex >= cpuRoot.history.length) return 2
            const val = cpuRoot.history[historyIndex]
            // Scale 0-100 to 2-20px height
            return Math.max(2, (val / 100) * 20)
          }
          
          color: {
            if (historyIndex >= cpuRoot.history.length) {
              return Qt.rgba(1, 1, 1, 0.1)
            }
            
            const val = cpuRoot.history[historyIndex]
            const intensity = Math.min(val / 100, 1.0)
            
            if (intensity < 0.33) {
              return Qt.rgba(0.3, 0.6, 1.0, 0.8)
            } else if (intensity < 0.66) {
              return Qt.rgba(1.0, 0.8, 0.2, 0.8)
            } else {
              return Qt.rgba(1.0, 0.3, 0.3, 0.8)
            }
          }
        }
      }
    }
  }
}
