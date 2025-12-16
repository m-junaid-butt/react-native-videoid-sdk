// example/metro.config.js
const { getDefaultConfig } = require('@react-native/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Add these configurations
config.watchFolders = [path.resolve(__dirname, '..')];

config.resolver = {
  ...config.resolver,
  extraNodeModules: {
    'react-native-videoid-sdk': path.resolve(__dirname, '../src'),
  },
  nodeModulesPaths: [
    path.resolve(__dirname, 'node_modules'),
    path.resolve(__dirname, '../node_modules'),
  ],
};

module.exports = config;
