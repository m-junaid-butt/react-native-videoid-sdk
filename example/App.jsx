// example/App.js
import React from 'react';
import { View, Button, Alert, StyleSheet } from 'react-native';
import VideoIDSDK from 'react-native-videoid-sdk';

const App = () => {
  const config = {
    endpoint: 'https://etrust-sandbox.electronicid.eu/v2',
    bearer: 'fbd13b2e-d2fc-4b1d-8704-ee32e8856df9',
    rAuthority: '',
    documentID: 62, // Spain ID
    language: 'en',
  };

  const handleStart = async () => {
    try {
      console.log('Starting VideoID...');
      const result = await VideoIDSDK.start(config);

      console.log('VideoID completed:', result);

      if (result.videoID) {
        Alert.alert('Success', `VideoID: ${result.videoID}`);
      } else {
        Alert.alert('Success', 'VideoID process completed');
      }
    } catch (error) {
      console.error('Error:', error);
      Alert.alert('Error', error.message || 'Failed to start VideoID');
    }
  };

  const handleStartWithCustomStyle = async () => {
    try {
      console.log('Starting VideoID with custom style...');

      const styleConfig = {
        roiLinesColorSuccess: '#0000FF', // Blue
        mediaNotificationTextColor: '#0000FF', // Blue
        mediaNotificationFontSize: 28,
        linkButtonBackgroundColor: '#0000FF', // Blue
        textNotificationTextColor: '#0000FF', // Blue
      };

      const result = await VideoIDSDK.startWithCustomStyle(config, styleConfig);
      console.log('VideoID with custom style completed:', result);
      if (result.videoID) {
        Alert.alert('Success', `VideoID: ${result.videoID}`);
      } else {
        Alert.alert('Success', 'VideoID process completed');
      }
    } catch (error) {
      console.error('Error:', error);
      Alert.alert('Error', error.message || 'Failed to start VideoID');
    }
  };

  return (
    <View style={styles.container}>
      <Button title="Start VideoID SDK" onPress={handleStart} />
      <Button
        title="Start VideoID with Custom Style"
        onPress={handleStartWithCustomStyle}
        color="#0000FF"
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    gap: 20,
  },
});

export default App;
