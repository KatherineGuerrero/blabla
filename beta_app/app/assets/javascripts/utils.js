function caretChange(id, mode) {
    d = document.getElementById(id);
    if (mode == 'down') {
        d.className = "fa fa-caret-up";
        d.onclick = function () {caretChange(id, 'up')};
    } else if (mode == 'up') {
        d.className = "fa fa-caret-down";
        d.onclick = function () {caretChange(id, 'down')};
    }
}
