import { NativeModules, NativeEventEmitter } from 'react-native';

// Try different names
const VideoIDModule =
  NativeModules.VideoIDSdk || NativeModules.VideoID || NativeModules.VideoIdSdk;

console.log('Found VideoID module:', VideoIDModule);

const VideoIDSDK = {
  /**
   * Start VideoID SDK with default styling
   * @param {Object} params - Configuration parameters
   * @param {string} params.endpoint - API endpoint URL
   * @param {string} params.bearer - Bearer token
   * @param {string} params.rAuthority - R Authority (optional)
   * @param {number} params.documentID - Document type ID
   * @param {string} params.language - Language code (e.g., 'en', 'es')
   */
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

  /**
   * Start VideoID SDK with custom styling
   * @param {Object} params - Configuration parameters
   * @param {Object} styleConfig - Style configuration
   * @param {string} styleConfig.roiLinesColorSuccess - ROI success line color (hex)
   * @param {string} styleConfig.mediaNotificationTextColor - Media notification text color (hex)
   * @param {number} styleConfig.mediaNotificationFontSize - Media notification font size
   * @param {string} styleConfig.linkButtonBackgroundColor - Link button background color (hex)
   * @param {string} styleConfig.textNotificationTextColor - Text notification color (hex)
   */
  startWithCustomStyle: (params, styleConfig = {}) => {
    if (!VideoIDModule) {
      console.error(
        'VideoID native module not found. Available modules:',
        Object.keys(NativeModules)
      );
      return Promise.reject(new Error('VideoID native module not available'));
    }
    return VideoIDModule.startWithCustomStyle(params, styleConfig);
  },
};

export default VideoIDSDK;
