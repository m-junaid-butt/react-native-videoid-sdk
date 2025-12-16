// example/index.js
import { AppRegistry, NativeModules } from 'react-native';
import App from './App';
import { name as appName } from './app.json';

// Debug: List all native modules
console.log('All Native Modules:', Object.keys(NativeModules));

// Debug: Check specifically for VideoID
console.log('VideoID module exists?', !!NativeModules.VideoID);
console.log('VideoID module:', NativeModules.VideoID);

AppRegistry.registerComponent(appName, () => App);
