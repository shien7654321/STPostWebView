<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" name="viewport" content="width=device-width">
    <title>PageC</title>
    <link rel="stylesheet" href="page.css">
    <script src="pagebc.js"></script>
</head>
<body class="container">
<p class="header">PageC</p>
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
    <li>BackToPageA</li>
</ul>
</body>
</html>