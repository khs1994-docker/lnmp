<?php

file_put_contents('request.txt', file_get_contents("php://input"), FILE_APPEND);
file_put_contents('request.txt', "\n" , FILE_APPEND);
