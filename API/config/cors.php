<?php

return [

    'paths' => ['*'],   // semua endpoint API boleh diakses

    'allowed_methods' => ['*'],  // GET, POST, PUT, DELETE, DLL

    'allowed_origins' => ['*'],  // semua domain frontend boleh akses (Flutter Web)

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],  // semua header boleh

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];
