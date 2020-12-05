<?php

/**
 * @see https://github.com/code-lts/doctum
 *
 *  $ doctum update .doctum.php
 *  $ cd build ; php -S 0.0.0.0:8080
 *
 */

use Doctum\Doctum;
use Doctum\RemoteRepository\GitHubRemoteRepository;
use Doctum\Version\GitVersionCollection;
use Symfony\Component\Finder\Finder;

$iterator = Finder::create()
    ->files()
    ->name('*.php')
    // ->exclude('tests')
    ->in($dir = __DIR__.'/src');

// $versions = GitVersionCollection::create($dir)
//     ->addFromTags('18.*.*')// add tag
//     ->add('master', 'master branch'); // add branch

return new Doctum($iterator);

// return new Doctum($iterator, [
//         'theme'    => 'symfony',
//         'versions' => $versions,
//         'title' => 'Title API',
//         'build_dir' => __DIR__.'/build/%version%',
//         'cache_dir' => __DIR__.'/cache/%version%',
//         'remote_repository' => new GitHubRemoteRepository('username/repo', __DIR__),
//         'default_opened_level' => 2,
//     ]
// );
