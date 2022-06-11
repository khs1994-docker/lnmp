const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.js('resources/js/app.js', 'public/js').vue()
    .js('resources/js/a.js', 'public/js').vue()
    .postCss('resources/css/app.css', 'public/css', [
        require('tailwindcss'),
    ])
    .alias({
      '@': 'resources/js',
    });

// if (mix.inProduction()) {
//     mix.version();
// }

mix.version();

mix.then(() => {
  const convertToFileHash = require("laravel-mix-make-file-hash");
  convertToFileHash({
      publicPath: "public",
      manifestFilePath: "public/mix-manifest.json"
  });
});
