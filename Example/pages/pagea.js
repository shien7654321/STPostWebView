'use strict';

onload = function (ev) {
    var mainTableView = document.getElementById('mainTableViewAction');
    var lis = mainTableView.getElementsByTagName('li');
    for (var i = 0; i < lis.length; i++) {
        (function (index) {
            lis[index].onclick = function () {
                window.tableViewActionDidSelect(index);
            }
        })(i);
    }
};

function tableViewActionDidSelect(row) {
    if (row === 0) {
        window.webkit.messageHandlers.ToPageB.postMessage({})
    } else if (row === 1) {
        window.webkit.messageHandlers.ToPageC.postMessage({})
    }
}
