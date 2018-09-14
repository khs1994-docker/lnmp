<?php

/**
 * @see https://github.com/FriendsOfPHP/Sami
 *
 *  $ curl -fsSL http://get.sensiolabs.org/sami.phar /usr/local/bin/sami
 *  $ chmod +x /usr/local/bin/sami
 *
 *  $ sami update .sami.php
 *  $ cd build ; php -S 0.0.0.0:8080
 *
 */

use Sami\Sami;
use Sami\RemoteRepository\GitHubRemoteRepository;
use Sami\Version\GitVersionCollection;
use Symfony\Component\Finder\Finder;

$iterator = Finder::create()
    ->files()
    ->name('*.php')
    // ->exclude('tests')
    ->in($dir = __DIR__.'/src');

// $versions = GitVersionCollection::create($dir)
//     ->addFromTags('18.*.*')// add tag
//     ->add('master', 'master branch'); // add branch

return new Sami($iterator);

// return new Sami($iterator, [
//         'versions' => $versions,
//         'title' => 'Title API',
//         'build_dir' => __DIR__.'/build/%version%',
//         'cache_dir' => __DIR__.'/cache/%version%',
//         'remote_repository' => new GitHubRemoteRepository('username/repo', __DIR__),
//     ]
// );
