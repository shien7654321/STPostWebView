<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" name="viewport" content="width=device-width">
    <title>PageA</title>
    <link rel="stylesheet" href="page.css">
    <script src="pagea.js"></script>
</head>
<body class="container">
<p class="header">PageA</p>
<p class="tableViewHeader">Params</p>
<ul id="mainTableViewParams" class="tableView">
    <li>GET:
        <?php
        foreach ($_GET as $key => $value) {
            echo ' ' . $key . '=' . $value;
        }
        ?>
    </li>
    <li>POST:
        <?php
        foreach ($_POST as $key => $value) {
            echo ' ' . $key . '=' . $value;
        }
        ?>
    </li>
</ul>
<p class="tableViewHeader">Action</p>
<ul id="mainTableViewAction" class="tableView">
    <li>ToPageB</li>
    <li>ToPageC</li>
</ul>
</body>
</html>