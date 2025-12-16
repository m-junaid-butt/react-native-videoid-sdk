import { NativeModules, NativeEventEmitter } from 'react-native';

// Try different names
const VideoIDModule =
  NativeModules.VideoIDSdk || NativeModules.VideoID || NativeModules.VideoIdSdk;

console.log('Found VideoID module:', VideoIDModule);

const emitter = VideoIDModule ? new NativeEventEmitter(VideoIDModule) : null;

const VideoIDSDK = {
  start: (params) => {
    if (!VideoIDModule) {
      console.error(
        'VideoID native module not found. Available modules:',
        Object.keys(NativeModules)
      );
      return Promise.reject(new Error('VideoID native module not available'));
    }
    return VideoIDModule.start(params);
  },
  // ... rest of your code
};

export default VideoIDSDK;
