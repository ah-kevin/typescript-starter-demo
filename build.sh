#!/usr/bin/env bash
rm -rf publish

echo 'Compiling to es2015 via compiler'
$(npm bin)/tsc -p tsconfig-build.json -t es2015 --outDir publish-es2015/src

echo 'Bundling to es module of es2015'
export ROLLUP_TARGET=esm
$(npm bin)/rollup -c rollup.config.js -f es -i publish-es2015/src/index.js -o publish-es2015/esm2015/index.js

echo 'Compiling to es5 via  compiler'
$(npm bin)/tsc -p tsconfig-build.json -t es5 --outDir publish-es5/src

echo 'Bundling to es module of es5'
export ROLLUP_TARGET=esm
$(npm bin)/rollup -c rollup.config.js -f es -i publish-es5/src/index.js -o publish-es5/esm5/index.js

echo 'Bundling to umd module of es5'
export ROLLUP_TARGET=umd
$(npm bin)/rollup -c rollup.config.js -f umd -i publish-es5/esm5/index.js -o publish-es5/bundles/index.umd.js

echo 'Bundling to minified umd module of es5'
export ROLLUP_TARGET=mumd
$(npm bin)/rollup -c rollup.config.js -f umd -i publish-es5/esm5/index.js -o publish-es5/bundles/index.umd.min.js

echo '统一发布文件夹'
mv publish-es5 publish
mv publish-es2015/esm2015 publish/esm2015
trash publish-es2015

echo '清除临时文件夹'
rm -rf publish/src/*.js
rm -rf publish/src/**/*.js

echo '统一entry files'
sed -e "s/from '.\//from '.\/src\//g" publish/src/index.d.ts > publish/index.d.ts
rm publish/src/index.d.ts

echo 'Copying package.json'
cp package.json publish/package.json
