const path = require('path');
const pkg = require('./package.json');

module.exports = {
  project: {
    ios: {},
    android: {},
  },
  dependencies: {
    [pkg.name]: {
      root: __dirname,
      platforms: {
        ios: {
          podspecPath: path.join(__dirname, 'VideoidSdk.podspec'),
        },
        android: {},
      },
    },
  },
  codegenConfig: {
    name: 'VideoidSdkSpec', // this becomes <VideoidSdkSpec/VideoidSdkSpec.h>
    type: 'modules',
    jsSrcsDir: './src',     // folder where your spec TS file lives
  },
};
