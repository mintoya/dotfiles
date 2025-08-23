pragma Singleton

import QtQuick
QtObject {

    <* for name, value in colors *>
    property string {{name}}: "{{value.default.hex}}"
    <* endfor *>

}

