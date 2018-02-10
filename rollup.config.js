import resolve from 'rollup-plugin-node-resolve';
import uglify from 'rollup-plugin-uglify';
import sourcemaps from 'rollup-plugin-sourcemaps';

const target = process.env.ROLLUP_TARGET || 'esm';
let globals = {};
let plugins = [
  sourcemaps(),
  resolve(),
];

switch (target) {
  case 'esm':
    Object.assign(globals, {
      'tslib': 'tslib',
    });
    break;
  case 'mumd':
    plugins.push(uglify());
    break;
}
export default {
  output: {
    plugins,
    sourcemap: true,
    exports: 'named',
    name: 'ifly.date',
    globals,
  },
  external: Object.keys(globals),
}
